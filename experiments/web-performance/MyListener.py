import json
import os
from datetime import datetime, timezone, timedelta
from urllib.parse import urlparse

from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn

from Browser.utils import ScreenshotFileTypes


def _parse_iso_datetime(value: str) -> datetime:
    """Return timezone-aware datetime for HAR timestamps."""
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def _now_utc() -> datetime:
    return datetime.now(timezone.utc)


def _parse_robot_time(value: str | None) -> datetime:
    """Parse Robot Framework timestamp (local time) to timezone-aware datetime."""
    if not value:
        return _now_utc()
    try:
        # Robot timestamps are in local time, parse as naive then make timezone-aware
        naive_dt = datetime.strptime(value, "%Y%m%d %H:%M:%S.%f")
        # Use system local timezone
        return naive_dt.replace(tzinfo=datetime.now().astimezone().tzinfo)
    except ValueError:
        return _now_utc()

class MyListener:
    ROBOT_LISTENER_API_VERSION = 3
    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    

    def __init__(self, take_screenshots: bool = False):
        self.ROBOT_LIBRARY_LISTENER = self
        self.keyword_windows = []
        self._keyword_stack = []
        self.take_screenshots = take_screenshots
        self.screenshot_dir = None
        # Initialize screenshot directory if enabled
        if self.take_screenshots:
            output_dir = BuiltIn().get_variable_value("${OUTPUT_DIR}")
            self.screenshot_dir = os.path.join(output_dir, "screenshots")
            os.makedirs(self.screenshot_dir, exist_ok=True)
            logger.info(f"Screenshot directory initialized: {self.screenshot_dir}")
    
    def start_suite(self, data, result):
        if data.parent is None:
            self.keyword_windows = []
            self._keyword_stack = []
            
    
    def start_keyword(self, data, result):
        keyword_name = getattr(data, "kwname", None) or getattr(data, "name", "")
        parent = getattr(data, "parent", None)
        parent_longname = getattr(parent, "longname", "") if parent else ""
        
        if parent_longname:
            label = f"{parent_longname}.{keyword_name}"
        else:
            label = keyword_name

        test_name = BuiltIn().get_variable_value("${TEST NAME}", default="")
        suite_name = BuiltIn().get_variable_value("${SUITE NAME}", default="")
        start_time = _parse_robot_time(getattr(data, "starttime", None))
        keyword_id = getattr(data, "id", "")

        window = {
            "label": label,
            "id": keyword_id,
            "test": test_name,
            "suite": suite_name,
            "start": start_time,
            "end": None,
        }
        self.keyword_windows.append(window)
        self._keyword_stack.append(window)

    def end_keyword(self, data, result):
        if not self._keyword_stack:
            return
        window = self._keyword_stack.pop()
        window["end"] = _parse_robot_time(getattr(result, "endtime", None))
        
        # Capture screenshot if enabled
        if self.take_screenshots and self.screenshot_dir:
            screenshot_path = self._capture_screenshot(window)
            if screenshot_path:
                window["screenshot"] = os.path.basename(screenshot_path)
        
    def _capture_screenshot(self, window: dict) -> str | None:
        """Capture a screenshot using Browser library's take_screenshot function."""
        try:
            # Get Browser library instance
            browser_lib = BuiltIn().get_library_instance('Browser')
            
            # Generate filename from keyword ID and timestamp
            keyword_id = window.get('id', 'unknown').replace('-', '_')
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S_%f')[:-3]
            filename = f"kw_{keyword_id}_{timestamp}.jpg"
            filepath = os.path.join(self.screenshot_dir, filename)
            
            # Take screenshot with compression settings
            # Using low resolution (800px width), JPEG format with 60% quality
            
            browser_lib.take_screenshot(
                filename=filepath,
                fileType=ScreenshotFileTypes.jpeg,
                quality=40,
                fullPage=False,
                log_screenshot=False,
                return_as='path_string'
            )
            
            logger.debug(f"Screenshot captured: {filename}")
            return filepath
            
        except Exception as e:
            # Silently fail if Browser library not available or page not ready
            logger.debug(f"Could not capture screenshot for {window.get('label', 'unknown')}: {e}")
            return None
    
    def end_suite(self, data, result):
        output_dir = BuiltIn().get_variable_value("${OUTPUT_DIR}")     
        # locate the file har.file in the output directory
        har_file_path = f"{output_dir}/har.file"
        har_data = None
        try:
            with open(har_file_path, 'r') as har_file:
                har_data = json.load(har_file)
                mapping = self._build_keyword_network_mapping(har_data, data.name, har_file_path)
                self._log_keyword_network_mapping(mapping)
                self._write_keyword_mapping_json(har_file_path, mapping)
        except FileNotFoundError:
            logger.warn(f"HAR file not found at {har_file_path}")
        except Exception as e:
            logger.error(f"Error reading HAR file: {e}")
        pass

    def _build_keyword_network_mapping(self, har_data, suite_name: str, har_path: str):
        entries = har_data.get('log', {}).get('entries', [])
        page_timings = self._extract_page_timings(har_data)

        keyword_records = []
        record_by_window = {}
        entry_by_window = {}  # Track all entries per window for metrics
        
        for window in self.keyword_windows:
            record = {
                'suite': window['suite'] or suite_name,
                'test': window['test'],
                'keyword': window['label'],
                'id': window.get('id', ''),
                'start': window['start'].isoformat(),
                'end': (window['end'] or window['start']).isoformat(),
                'duration_ms': int((window['end'] - window['start']).total_seconds() * 1000) if window.get('end') else 0,
                'api_calls': [],
                'assets': {},
            }
            
            # Add screenshot reference if available
            if 'screenshot' in window:
                record['screenshot'] = window['screenshot']
            
            keyword_records.append(record)
            record_by_window[id(window)] = record
            entry_by_window[id(window)] = []

        unmatched_entries = 0
        for entry in entries:
            started = entry.get('startedDateTime')
            duration_ms = entry.get('time', 0)
            if not started or duration_ms == -1:
                unmatched_entries += 1
                continue

            har_start = _parse_iso_datetime(started)
            har_end = har_start + timedelta(milliseconds=duration_ms)
            window = self._match_window(har_start, har_end)
            if not window:
                unmatched_entries += 1
                continue

            record = record_by_window.get(id(window))
            if not record:
                unmatched_entries += 1
                continue

            # Store entry for later metrics calculation
            entry_by_window[id(window)].append(entry)

            # Classify and aggregate
            req_type = self._classify_request(entry)
            if req_type == 'api':
                record['api_calls'].append(self._extract_api_call(entry))
            else:
                self._add_to_asset_group(record['assets'], req_type, duration_ms)

        # Add performance metrics, errors, and connection quality
        for window_id, record in record_by_window.items():
            window_entries = entry_by_window[window_id]
            if window_entries:
                record['performance'] = self._calculate_performance_metrics(window_entries)
                record['errors'] = self._calculate_error_metrics(window_entries)
                record['connection'] = self._calculate_connection_metrics(window_entries)
            
            # Add page timings if available (typically for navigation keywords)
            if page_timings and window_entries and self._contains_document_request(window_entries):
                record['page_timings'] = page_timings
            
            # Group API calls by endpoint
            if record['api_calls']:
                record['api_calls'] = self._group_api_calls(record['api_calls'])
            else:
                del record['api_calls']
                
            if not record['assets']:
                del record['assets']

        return {
            'schema_version': '1.0',
            'generated_at': _now_utc().isoformat(),
            'har_source': os.path.basename(har_path),
            'suite': suite_name,
            'total_har_entries': len(entries),
            'unmatched_entries': unmatched_entries,
            'keywords': keyword_records,
        }

    def _extract_page_timings(self, har_data: dict) -> dict:
        """Extract page load metrics from HAR."""
        pages = har_data.get('log', {}).get('pages', [])
        if not pages:
            return {}
        
        timings = pages[0].get('pageTimings', {})
        dom_content = timings.get('onContentLoad', 0)
        page_load = timings.get('onLoad', 0)
        
        if dom_content <= 0 and page_load <= 0:
            return {}
        
        return {
            'dom_content_loaded_ms': dom_content if dom_content > 0 else 0,
            'page_load_ms': page_load if page_load > 0 else 0,
        }

    def _contains_document_request(self, entries: list[dict]) -> bool:
        """Check if entries contain a document (HTML) request."""
        for entry in entries:
            if self._classify_request(entry) == 'document':
                return True
        return False

    def _classify_request(self, entry: dict) -> str:
        """Categorize request by type for aggregation."""
        url = entry.get('request', {}).get('url', '')
        mime = entry.get('response', {}).get('content', {}).get('mimeType', '')
        
        if 'api.' in url or '/api/' in url:
            return 'api'
        elif mime.startswith('image/'):
            return 'asset_image'
        elif mime in ('text/css', 'application/javascript', 'application/x-javascript'):
            return 'asset_code'
        elif mime == 'text/html':
            return 'document'
        return 'other'

    def _extract_api_call(self, entry: dict) -> dict:
        """Extract API request with timing details."""
        url = entry.get('request', {}).get('url', '')
        url_parts = urlparse(url)
        timings = entry.get('timings', {})
        
        return {
            'method': entry.get('request', {}).get('method', ''),
            'endpoint': url_parts.path,
            'duration_ms': entry.get('time', 0),
            'status': entry.get('response', {}).get('status', 0),
            'wait_ms': timings.get('wait', 0) if timings.get('wait', 0) > 0 else 0,
            'ssl_ms': timings.get('ssl', 0) if timings.get('ssl', 0) > 0 else 0,
        }

    def _add_to_asset_group(self, assets: dict, asset_type: str, duration_ms: float):
        """Aggregate asset statistics by type."""
        if asset_type not in assets:
            assets[asset_type] = {
                'count': 0,
                'total_ms': 0,
                'max_ms': 0,
            }
        
        assets[asset_type]['count'] += 1
        assets[asset_type]['total_ms'] = round(assets[asset_type]['total_ms'] + duration_ms, 3)
        assets[asset_type]['max_ms'] = max(assets[asset_type]['max_ms'], duration_ms)

    def _calculate_performance_metrics(self, entries: list[dict]) -> dict:
        """Calculate performance metrics from HAR entries."""
        durations = [e.get('time', 0) for e in entries if e.get('time', 0) > 0]
        api_wait_times = []
        
        for entry in entries:
            url = entry.get('request', {}).get('url', '')
            if 'api.' in url or '/api/' in url:
                timings = entry.get('timings', {})
                wait = timings.get('wait', 0)
                if wait > 0:
                    api_wait_times.append(wait)
        
        return {
            'network_time_ms': round(sum(durations), 3),
            'backend_wait_ms': round(sum(api_wait_times), 3),
            'slowest_request_ms': round(max(durations), 3) if durations else 0,
            'request_count': len(durations),
        }

    def _calculate_error_metrics(self, entries: list[dict]) -> dict:
        """Calculate error metrics from HAR entries."""
        http_4xx = 0
        http_5xx = 0
        failed = 0
        slow = 0
        slow_threshold_ms = 500
        
        for entry in entries:
            status = entry.get('response', {}).get('status', 0)
            duration = entry.get('time', 0)
            failure = entry.get('response', {}).get('_failureText')
            
            if 400 <= status < 500:
                http_4xx += 1
            elif status >= 500:
                http_5xx += 1
            
            if failure or duration == -1:
                failed += 1
            
            if duration > slow_threshold_ms:
                slow += 1
        
        return {
            'http_4xx': http_4xx,
            'http_5xx': http_5xx,
            'failed': failed,
            'slow': slow,
        }

    def _calculate_connection_metrics(self, entries: list[dict]) -> dict:
        """Calculate connection quality metrics from HAR entries."""
        tls_times = []
        dns_times = []
        cache_hits = 0
        
        for entry in entries:
            timings = entry.get('timings', {})
            duration = entry.get('time', 0)
            
            # TLS handshake
            ssl = timings.get('ssl', 0)
            if ssl > 0:
                tls_times.append(ssl)
            
            # DNS resolution
            dns = timings.get('dns', 0)
            if dns > 0:
                dns_times.append(dns)
            
            # Cache hits (very fast responses)
            if 0 < duration < 5:
                cache_hits += 1
        
        return {
            'tls_handshake_avg_ms': round(sum(tls_times) / len(tls_times), 3) if tls_times else 0,
            'dns_avg_ms': round(sum(dns_times) / len(dns_times), 3) if dns_times else 0,
            'cache_hits': cache_hits,
        }

    def _group_api_calls(self, api_calls: list[dict]) -> list[dict]:
        """Group API calls by endpoint and aggregate metrics."""
        endpoint_map = {}
        
        for call in api_calls:
            key = (call['method'], call['endpoint'])
            if key not in endpoint_map:
                endpoint_map[key] = {
                    'method': call['method'],
                    'endpoint': call['endpoint'],
                    'count': 0,
                    'durations': [],
                    'errors': 0,
                }
            
            endpoint_map[key]['count'] += 1
            endpoint_map[key]['durations'].append(call['duration_ms'])
            
            # Count errors (4xx, 5xx, or 0)
            if call['status'] >= 400 or call['status'] == 0:
                endpoint_map[key]['errors'] += 1
        
        # Convert to final format
        result = []
        for key, data in endpoint_map.items():
            durations = data['durations']
            result.append({
                'method': data['method'],
                'endpoint': data['endpoint'],
                'count': data['count'],
                'avg_ms': round(sum(durations) / len(durations), 3) if durations else 0,
                'max_ms': round(max(durations), 3) if durations else 0,
                'errors': data['errors'],
            })
        
        return result


    def _log_keyword_network_mapping(self, mapping):
        entries = mapping.get('keywords') or []
        if not entries:
            logger.info("HAR does not contain entries to map")
            return

        logger.info(f"HAR keyword mapping (schema v{mapping.get('schema_version', '?')})")
        for record in entries:
            keyword_name = record['keyword']
            duration = record.get('duration_ms', 0)
            
            # Performance metrics
            perf = record.get('performance', {})
            network_time = perf.get('network_time_ms', 0)
            backend_wait = perf.get('backend_wait_ms', 0)
            slowest = perf.get('slowest_request_ms', 0)
            req_count = perf.get('request_count', 0)
            
            # Error metrics
            errors = record.get('errors', {})
            error_summary = f"4xx:{errors.get('http_4xx', 0)} 5xx:{errors.get('http_5xx', 0)} failed:{errors.get('failed', 0)} slow:{errors.get('slow', 0)}"
            
            # Connection metrics
            conn = record.get('connection', {})
            conn_summary = f"TLS:{conn.get('tls_handshake_avg_ms', 0)}ms DNS:{conn.get('dns_avg_ms', 0)}ms cache:{conn.get('cache_hits', 0)}"
            
            # Page timings
            page = record.get('page_timings', {})
            page_summary = ""
            if page:
                dom = page.get('dom_content_loaded_ms', 0)
                load = page.get('page_load_ms', 0)
                page_summary = f" | Page: DOM:{dom}ms Load:{load}ms"
            
            logger.info(
                f"{keyword_name} ({duration}ms): "
                f"{req_count} requests, network:{network_time}ms, backend:{backend_wait}ms, slowest:{slowest}ms{page_summary}"
            )
            logger.info(f"  Errors: {error_summary}")
            logger.info(f"  Connection: {conn_summary}")
            
            # Log API calls
            for api in record.get('api_calls', []):
                logger.info(
                    f"  API: {api['method']} {api['endpoint']} "
                    f"x{api['count']} -> avg:{api['avg_ms']}ms max:{api['max_ms']}ms errors:{api['errors']}"
                )
            
            # Log asset summary
            assets = record.get('assets', {})
            for asset_type, stats in assets.items():
                logger.info(
                    f"  {asset_type}: {stats['count']} files, "
                    f"{stats['total_ms']}ms total, {stats['max_ms']}ms max"
                )

        unmatched = mapping.get('unmatched_entries', 0)
        if unmatched:
            logger.info(f"HAR entries without keyword mapping: {unmatched}")

    def _write_keyword_mapping_json(self, har_file_path: str, mapping):
        base, _ = os.path.splitext(har_file_path)
        output_path = f"{base}-keyword-map.json"
        try:
            with open(output_path, 'w', encoding='utf-8') as mapping_file:
                json.dump(mapping, mapping_file, indent=2)
            logger.info(f"Keyword-to-network mapping written to {output_path}")
        except Exception as exc:
            logger.error(f"Failed to write keyword mapping JSON: {exc}")

    def _match_window(self, har_start: datetime, har_end: datetime):
        for window in reversed(self.keyword_windows):
            start = window['start']
            end = window.get('end') or start
            if start <= har_end and har_start <= end:
                return window
        return None

def get_instance():
    return MyListener()
