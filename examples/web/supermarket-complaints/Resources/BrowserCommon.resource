*** Settings ***

Library  Browser  
...    enable_playwright_debug=disabled
...    run_on_failure=Take Screenshot \ EMBED \ fileType=jpeg \ quality=80
...    tracing_group_mode=Browser
...    auto_delete_passed_tracing=true

*** Variables ***
${BROWSER}  chromium
${HEADLESS}     False

*** Keywords ***
Browser Init
    [Documentation]    Creates the Browser instance.
    [Arguments]    ${browser}
    New Browser    headless=${HEADLESS}    browser=${browser}  slowMo=0.6s
    

Session Init
    [Documentation]    Creates Context (=profile) and Page (=tab).
    [Arguments]    ${url}=${EMPTY}   
    New Context    locale=en-US    viewport={"width": 1920, "height": 1080}
    New Page    ${url}