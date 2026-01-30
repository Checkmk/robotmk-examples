*** Settings ***
Library           Browser  run_on_failure=Take Screenshot \ EMBED


*** Keywords ***

Take A Screenshot
    [Arguments]  ${selector}=${None}
    
    Browser.Take Screenshot  EMBED  ${selector}