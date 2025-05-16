*** Settings ***

Documentation       This is a minimal test suite to demonstrate a web test case using 
...    Browser library (https://robotframework-browser.org), based on Playwright. 

# Instead of saving the screenshots to the file system, the screenshots are embedded in the log file.
Library             Browser    run_on_failure=Take Screenshot \ EMBED \ fileType=jpeg \ quality=50

*** Variables ***
${SEARCH_ENGINE}  https://www.google.com?hl=en
${SEARCH_TERM}   Checkmk Synthetic Monitoring

*** Test Cases ***
Perform a Google Search 
    [Documentation]    Opens Google and performs a search for a specific query.
    New Browser  browser=firefox  headless=False
    New Context  locale=en-GB
    New Page  ${SEARCH_ENGINE} 
    Click  text="Accept all"
    Fill Text  selector=textarea[title=Search]  txt=${SEARCH_TERM}
    Keyboard Key  press  Enter
    Sleep  3
    # Wait for the search results to contain the search term
    Get Text  div\#search  *=  ${SEARCH_TERM}
    Take Screenshot  EMBED  selector=div\#search