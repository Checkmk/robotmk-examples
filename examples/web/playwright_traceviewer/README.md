# Traceviewer

## enable tracing 

`New Context  locale=en-US  tracing=trace.zip`
OR 
`ROBOT_FRAMEWORK_BROWSER_TRACING=trace.zip`


## viewing the trace

`rfbrowser show-trace trace_Browser.zip`


`for trace in trace_*.zip; do rfbrowser show-trace $trace ; done`


