*** Settings ***
Documentation       This suite shows how to perform a login with the CryptoLibrary
Library     Browser
...             enable_playwright_debug=disabled
...             auto_delete_passed_tracing=True

Library    CryptoLibrary    
...    key_path=keys
...    password=%{RMKCRYPTPW}
...    variable_decryption=True    

Suite Setup   Suite Initialization
Test Setup  Test Initialization

*** Variables ***

${URL}      https://practicetestautomation.com/practice-test-login/
${USERNAME}  student
${PASSWORD_CLEAR}  Password123  # this is BAD!
${PASSWORD_CRYPT}  crypt:s7Jiwve6YIzsyqVlGxndTAjIYQqg84lTT/1it/pqcCsV0w81Kfk0tQc4M1kiDxnqO1i0J9ZtgH0BUSA=

*** Test Cases ***

Login With Clear Text Password
    Fill Text  id=username  ${USERNAME}
    Fill Text  id=password  ${PASSWORD_CLEAR}
    Click  id=submit
    Wait For Condition  Text  body  contains  Logged In Successfull

Login With CryptoLibrary
    Fill Text  id=username  ${USERNAME}
    Fill Secret  id=password  $PASSWORD_CLEAR
    Click  id=submit
    Wait For Condition  Text  body  contains  Logged In Successfull


*** Keywords ***
Suite Initialization
    # Show the browser UI in case the env variable is not set
    New Browser    chromium  headless=%{ROBOTMK_HEADLESS_HOST=false}  slowMo=1s
    
Test Initialization
    New Context   
    New Page    url=${URL}