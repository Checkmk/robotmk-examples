*** Settings ***
Library  Browser
Suite Setup   New Browser  headless=${HEADLESS}

*** Variables ***
${HEADLESS}     False
${TEST_TOKEN}  544ea07f
${REQUEST_ID}  ${EMPTY}
${URL}       https://supermarket-complaints.demo.robotmk.org/

*** Test Cases ***
Create Complaint
    [Setup]  New Page  ${URL}
    Submit Form
    Save Complaint ID

Search Complaint
    [Setup]  New Page  ${URL}/mailbox 
    Login   agent   ${TEST_TOKEN}
    Search Complaint  ${REQUEST_ID}
    
*** Keywords ***


Submit Form
    Fill Text  id=subject  Temperature
    Fill Text  id=message  Its too cold!
    Fill Text  id=city  Munich
    Fill Text  id=token  ${TEST_TOKEN}
    Click  id=submit-btn


Save Complaint ID
    ${id}=   Get Text  id=request-id
    VAR  ${REQUEST_ID}  ${id}   scope=suite
    Sleep  2

Login
    [Arguments]    ${username}    ${password}
    Fill Text  id=username  ${username}
    Fill Text  id=password  ${password}
    Click  id=login-btn


Search Complaint
    [Arguments]    ${arg1}
    Fill Text  id=filter  ${arg1}
    Click  id=search
    Get Text  id=results  contains  ${request_id}  msg=Request {expected} not found!


