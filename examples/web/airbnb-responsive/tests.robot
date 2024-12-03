*** Settings ***
Documentation       This suite show how to use different viewports to simulate
...  mobile devices. The full list of devices can be found here:
...  https://github.com/microsoft/playwright/blob/main/packages/playwright-core/src/server/deviceDescriptorsSource.json
Library             Browser  enable_presenter_mode=True

Suite Setup         New Browser    headless=${HEADLESS}  
Suite Teardown      Close Browser
Test Setup          New Context
Test Teardown       Close Context


*** Variables ***
${HEADLESS}     False
${URL}       https://airbnb.com 


*** Test Cases ***
Find A Co-Host On iPhone X
    ${device}=          Get Device       iPhone X
    New Context  &{device}
    New Page     ${URL}
    Search Co-Host

Find A Co-Host On Nexus 6
    ${device}=          Get Device       Nexus 6 landscape
    New Context  &{device}
    New Page     ${URL}
    Search Co-Host

Find A Co-Host On Desktop
    New Context
    New Page    ${URL}
    Search Co-Host

*** Keywords ***
Search Co-Host
    Scroll To Element  text=Find a co‑host
    Click       text=Find a co‑host
    Click       span >> text=Find a co‑host >> nth=2
    Fill Text   input  München,Marienplatz 1
    Click   li#cohost-marketplace-search-list-0
    Sleep  2

