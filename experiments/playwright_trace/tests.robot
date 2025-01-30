*** Settings ***

Documentation       This is a minimal test suite to demonstrate a web test case using 
...    Browser library (https://robotframework-browser.org), based on Playwright. 

# Instead of saving the screenshots to the file system, the screenshots are embedded in the log file.
Library             Browser    
...    run_on_failure=Take Screenshot \ EMBED \ fileType=jpeg \ quality=50
...    tracing_group_mode=${MODE}
# ...    tracing_group_mode=Browser
# ...    tracing_group_mode=Playwright

*** Variables ***
${BROWSER}        chromium
${SEARCH_ENGINE}  https://www.google.com?hl=en
${SEARCH_QUERY}   "Checkmk" "Synthetic Monitoring"
${MODE}  Full
#${MODE}  Browser
#${MODE}  Playwright

&{HAR_CFG}   path=${OUTPUTDIR}/har.file    omitContent=True
&{VIDEO_CFG}   dir=${OUTPUTDIR}/videos  

*** Test Cases ***
Perform a Google Search
    [Documentation]    Opens Google and performs a search for a specific query.
    Browser Init
    Accept Cookies
    Perform Search
    Take Screenshot  EMBED  fileType=jpeg  quality=50

Log Test 
    Log  CMD_VAR: ${CMD_VAR}
    Log  CMD_VAR__LONG: ${CMD_VAR_LONG}
    Log  ENVIRONMENT: %{ENVIRONMENT}




*** Keywords ***

Browser Init
    New Browser  browser=${BROWSER}  headless=False
    New Context  locale=en-US  
    ...    tracing=trace_${MODE}.zip
    #...    recordHar=&{HAR_CFG}
    ...    recordVideo=&{VIDEO_CFG}
    New Page  ${SEARCH_ENGINE} 

Accept Cookies
    Click  text="Accept all"

Perform Search
    Fill Text   textarea[title=Search]    ${SEARCH_QUERY}
    Keyboard Key  press  Enter
    Sleep  2