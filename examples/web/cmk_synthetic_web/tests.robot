*** Settings ***

Documentation       This is a minimal test suite to demonstrate a web test case using 
...    Browser library (https://robotframework-browser.org), based on Playwright. 

# Instead of saving the screenshots to the file system, the screenshots are embedded in the log file.
Library             Browser    run_on_failure=Take Screenshot \ EMBED \ fileType=jpeg \ quality=50

*** Variables ***
${SEARCH_ENGINE}  https://www.google.com?hl=en
${SEARCH_QUERY}   "Checkmk" "Synthetic Monitoring"

*** Test Cases ***
Perform a Google Search
    [Documentation]    Opens Google and performs a search for a specific query.
    New Browser  browser=firefox
    New Context  locale=en-US
    New Page  ${SEARCH_ENGINE} 
    Click  text="Accept all"
    Fill Text   textarea[title=Search]    ${SEARCH_QUERY}
    Keyboard Key  press  Enter
    Sleep  2
    Take Screenshot  EMBED  fileType=jpeg  quality=50
