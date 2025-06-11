*** Settings ***
Documentation       This suite tests the supermarket complaints web application.
Resource  Resources/BrowserCommon.resource
Suite Setup         Browser Init  ${BROWSER}
Test Setup          Session Init

*** Variables ***
${BROWSER}  chromium
${HEADLESS}     False
${URL}       https://supermarket-complaints.demo.robotmk.org/


*** Test Cases ***
Submit A Complaint
    [Documentation]  Submit a new complaint to the supermarket and store the request ID.
    [Setup]   Session Init  ${URL}
    Fill Form
    Get Submission ID

Verify Complaint Reception
    [Documentation]  Verify that the request ID is searchable in the mailbox.
    [Setup]   Session Init  ${URL}/mailbox
    Login  agent   supersecure
    Search Complaint  ${REQUEST_ID}

Deny Mailbox Access With Wrong Credentials
    [Documentation]  Verify that mailbox access is denied with wrong credentials.
    [Setup]   Session Init  ${URL}/mailbox
    Login  agent   wrongpassword
    Expect Error Message

*** Keywords ***

Fill Form
    Fill Text  id=subject  Temperature
    Fill Text  id=message  It's too cold in your store!
    Fill Text  id=city  Munich
    Click  id=submit-btn

Get Submission ID
    ${id}=  Get Text  id=request-id
    VAR  ${REQUEST_ID}  ${id}  scope=SUITE
    Log  Request ID: ${REQUEST_ID}

Login
    [Arguments]  ${username}  ${password}
    Fill Text  id=username  ${username}
    Fill Text  id=password  ${password}
    Click  id=login-btn

Search Complaint
    [Arguments]  ${request_id}
    Fill Text  id=filter  ${request_id}
    Click  id=search
    Get Text  id=results  contains  ${request_id}  msg=Request {expected} not found!

Expect Error Message
    Get Text  id=login-error  contains  Invalid username or password