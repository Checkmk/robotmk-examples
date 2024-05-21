*** Settings ***

Library  Browser


*** Test Cases ***
Perform a Google Search 
    New Browser  browser=firefox  headless=False
    New Context  locale=en-GB
    New Page  url=https://www.google.com
    Click  text="Accept all"
    Fill Text  selector=textarea[title=Search]  txt="Checkmk" "Synthetic Monitoring"
    Keyboard Key  press  Enter
    Sleep  3
    Get Text  div\#search  *=  Checkmk Synthetic Monitoring with Robotmk
    Take Screenshot  EMBED  selector=div\#search