*** Settings ***
Documentation       This suite tests the supermarket complaints web application.

*** Variables ***
${BROWSER}  chromium
${HEADLESS}     False
${URL}       https://supermarket-complaints.demo.robotmk.org/


*** Test Cases ***
Submit A Complaint
    [Documentation]  Submit a new complaint to the supermarket and store the request ID.
    No Operation

Verify Complaint Reception
    [Documentation]  Verify that the request ID is searchable in the mailbox.
    No Operation

Deny Mailbox Access With Wrong Credentials
    [Documentation]  Verify that mailbox access is denied with wrong credentials.
    No Operation

*** Keywords ***
