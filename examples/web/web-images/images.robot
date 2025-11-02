*** Settings ***
Documentation       This suite shows how to check a web page for an expected image. 
...  Because the hero section isn't a static image (it changes every few seconds),
...  the test iterates through the image buttons ("dots") below the hero slider to
...  display each image in turn and checks if the expected motorcycle image is present.

# presenter mode is enabled to make it easier to follow along when the tests are run with UI.
Library             Browser   enable_presenter_mode=True
# DocTest.VisualTest library is used to perform image comparisons.
Library             DocTest.VisualTest   
Suite Setup         Suite Initialization

*** Variables ***
${URL}      https://sampleapp.tricentis.com

*** Test Cases ***

Hero Section Shows A Motorcycle Image
    [Documentation]    Verify that the hero section contains an image of a motorcycle.
    Search Image In Hero Section    img/motorcycle.png

*** Keywords ***
Suite Initialization
    # Launch the browser with UI and open the page    
    New Browser    chromium    headless=${False}  slowMo=0.2s
    # Setting a specific viewport size and locale is always recommended to ensure consistent test results
    New Context    viewport={ 'width': 1280, 'height': 1024 }  locale=us-US
    # Opening the page
    New Page    url=${URL}


Search Image In Hero Section
    [Arguments]    ${image_path}
    # CSS selector: Get the selectors for all image buttons (<li> elements) below the hero slider 
    ${img_buttons}=  Get Elements  div.hero-slider ol li    
    # Iterate through all image buttons ("dots") to find the expected image
    FOR   ${button}    IN    @{img_buttons}
        # Click the image button to change the hero image
        Click    ${button}
        # Wait 1s for the image transition (blur effect) to complete
        Sleep    1s
        # Take a screenshot of the current page, store path in variable
        ${page_screenshot}=  Take Screenshot  fileType=png
        # Check if the expected image is present in the screenshot
        ${found}=  Screenshot Contains Template Image   ${page_screenshot}   ${image_path}
        IF   ${found}   
            Set Test Message   Motorcycle Image Found in Hero Section! 
            RETURN
        END
    END
    Fail   The expected motorcycle image was not found in the Hero section!


Screenshot Contains Template Image
    [Documentation]    Verify that a given screenshot contains a specific template image.
    [Arguments]    ${screenshot}    ${template}
    # To prevent that the test fails immediately when the image is not found,
    # we use "Run Keyword And Return Status" to capture the result.
    # If the image is found, the status will be True, otherwise False.
    ${status}=  Run Keyword And Return Status
    ...  Image Should Contain Template  
    ...  image=${screenshot}  template=${template}  take_screenshots=True  threshold=0.2
    RETURN   ${status}
