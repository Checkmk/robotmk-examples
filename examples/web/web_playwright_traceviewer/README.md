# Browser Library Traceviewer

https://marketsquare.github.io/robotframework-browser/Browser.html#New%20Context

=> see "tracing"

## enable tracing 

`New Context  locale=en-US  tracing=trace.zip`
OR 
`ROBOT_FRAMEWORK_BROWSER_TRACING=trace.zip`


## viewing the trace

`rfbrowser show-trace path_to_trace_Browser.zip`

Open a series of traces: 

`for trace in trace_*.zip; do rfbrowser show-trace $trace ; done`


