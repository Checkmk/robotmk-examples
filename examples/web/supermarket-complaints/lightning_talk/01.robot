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
    No Operation

Search Complaint
    [Setup]  New Page  ${URL}/mailbox
    No Operation
    
*** Keywords ***
