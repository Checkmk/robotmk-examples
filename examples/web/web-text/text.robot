*** Settings ***
Documentation       This suite shows some examples of using the Browser Library to 
...   test if the web page shows certain text. 

# presenter mode is enabled to make it easier to follow along when the tests are run with UI.
Library             Browser   enable_presenter_mode=True
Suite Setup         Suite Initialization
# At the end of the suite, take a screenshot and embed it to the report
Suite Teardown      Take Screenshot  EMBED


*** Variables ***
${URL}      https://sampleapp.tricentis.com


*** Test Cases ***

Navigation Shows Expected Categories
    # "Get Text" is used to retrieve text from the page. 
    # "matches" is an assertion operator which allows to check the retrieved text against 
    # an expected value.
    # Instead of matching all the text at once, we check each category separately.
    # This way, we do not have to worry about the exact formatting of the text on the page.
    Get Text  .main-navigation  matches  Automobile
    Get Text  .main-navigation  matches  Truck
    Get Text  .main-navigation  matches  Motorcycle
    Get Text  .main-navigation  matches  Camper


*** Keywords ***
Suite Initialization
    # Launch the browser with UI and open the page    
    New Browser    firefox  headless=${False}  slowMo=1s
    # Setting a specific viewport size and locale is always recommended to ensure consistent test results
    New Context    viewport={ 'width': 1280, 'height': 720 }  locale=us-US
    # Opening the page
    New Page    url=${URL}
