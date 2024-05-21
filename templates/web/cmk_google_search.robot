*** Settings ***

Documentation       This is a minimal test suite to demonstrate a web test case using 
...    Browser library (https://robotframework-browser.org), based on Playwright. 

Library  Browser

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
    Get Text  div\#search  *=  ${SEARCH_TERM}
    Take Screenshot  EMBED  selector=div\#search