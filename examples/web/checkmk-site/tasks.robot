*** Settings ***
Documentation       Template robot main suite.

Library             Browser    run_on_failure=Take Screenshot \ EMBED

Suite Setup         Suite Initialization
Test Setup          Test Initialization


*** Variables ***
${URL}      http://192.168.56.1/heute
${USER}     cmkadmin
${PASS}     cmk


*** Test Cases ***
Readonly User Exists
    Open Users Administration
    No Operation
    Set Browser Timeout    2
    ${row}=    Get Table Row Index    iframe[name=main] >>> table.data >> "Testuser"
    ${column}=    Get Table Cell Index    iframe[name=main] >>> table.data >> "Roles"
    ${el}=    Get Table Cell Element    iframe[name=main] >>> table.data    "Roles"    "testuser"
    Get Text    ${el}    ==    Guest user


*** Keywords ***
Suite Initialization
    New Browser    headless=${False}

Test Initialization
    New Context    viewport=${None}
    New Page    url=${URL}
    Login    ${USER}    ${PASS}

Login
    [Arguments]    ${user}    ${pass}
    Fill Text    input#input_user    ${user}
    Fill Text    input#input_pass    ${pass}
    Click    input#_login

Open Users Administration
    Open Setup Menu
    Open Setup Users

Open Setup Menu
    Click    div#popup_trigger_mega_menu_setup

Open Setup Users
    Click    //a[.="Users"]
