*** Settings ***
Library   Browser   # enable_presenter_mode={'duration': 0.4s}
Library   SelfHealing   use_llm_for_locator_proposals=True  use_locator_db=True  collect_locator_info=True
Suite Setup   Suite Initialization

*** Variables ***
${URL}  https://practicesoftwaretesting.com
${USER}  customer@practicesoftwaretesting.com
${PASS}  welcome01
${HEADLESS}  False

*** Test Cases ***
User Can Log In Successfully
    [Documentation]  Verify that a user can log in with valid credentials.
    [Setup]  Test Initialization
    Click    text=Sign in
    Fill Text    id=email    ${USER}
    Fill Text    id=password    ${PASS}
    Click    data-test=login-submit
    Get Text  nav  matches  Jane Doe  message=Login failed: User name not found!

User Can Log In Successfully - Broken
    [Documentation]  Verify that a user can log in with valid credentials.
    [Setup]  Test Initialization
    Click    text=Sign in
    Fill Text    id=emailXXX    ${USER}
    Fill Text    id=passwordXXX    ${PASS}
    Click    data-test=login-submitXXX
    Get Text  nav  matches  Jane Doe  message=Login failed: User name not found!    

*** Keywords ***
Suite Initialization
    # Launch the browser with UI and open the page    
    New Browser    chromium    headless=${HEADLESS} 

Test Initialization
    # Setting a specific viewport size and locale is always recommended to ensure consistent test results
    New Context    viewport={ 'width': 1280, 'height': 1024 }  locale=us-US
    # Opening the page
    New Page    url=${URL}
