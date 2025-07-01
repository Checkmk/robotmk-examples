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
    [Arguments]    ${arg1}    ${arg2}
    # TODO: implement keyword "Login".
    Fail    Not Implemented


Search Complaint
    [Arguments]    ${arg1}
    # TODO: implement keyword "Search Complaint".
    Fail    Not Implemented



