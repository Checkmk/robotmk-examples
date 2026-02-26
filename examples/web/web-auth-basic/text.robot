*** Settings ***
Documentation       This suite shows how to perform a basic auth with Browser Library. 

Library             Browser

*** Variables ***

${URL}      https://testpages.eviltester.com/pages/auth/basic-auth/basic-auth-results.html
${USERNAME}  authorized
${PASSWORD}  password001

*** Test Cases ***

Do A Basic Auth Login
    # Show the browser UI in case the env variable is not set
    New Browser    chromium  headless=%{ROBOTMK_HEADLESS_HOST=false}  slowMo=1s
    # Pass the Basic Auth credentials. Note that the password is not written as a regular variable. 
    # This would expose its value into the logs. Instead, the `New Context` keyword internalls 
    # processes the $PASSWORD string and reads the value internally.
    # https://marketsquare.github.io/robotframework-browser/Browser.html#New%20Context
    # To encrypt the password in line 10, use the CryptoLibrary: 
    # https://snooz82.github.io/robotframework-crypto/CryptoLibrary.html 
    New Context    httpCredentials={'username': '${USERNAME}', 'password': '$PASSWORD'}
    New Page    url=${URL}
    Wait For Condition  Text  
    ...    .pageinfo  contains  You were Authenticated  
    ...    msg=Authentication error!