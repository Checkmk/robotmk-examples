# Traceviewer

## enable tracing 

`New Context  locale=en-US  tracing=trace.zip`
OR 
`ROBOT_FRAMEWORK_BROWSER_TRACING=trace.zip`


## viewing the trace


### default 

`rfbrowser show-trace trace.zip`

`for trace in trace_*.zip; do rfbrowser show-trace $trace ; done`


