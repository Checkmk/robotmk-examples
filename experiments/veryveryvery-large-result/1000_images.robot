*** Settings ***
Library  Browser  run_on_failure=Take Embedded Screenshot

*** Variables ***


*** Test Cases ***

Test One
    New Browser  headless=False  args=["--start-maximized"]
     New Context  viewport=None
    New Page  https://www.google.com
    FOR    ${i}    IN RANGE    1    1000
        Take Embedded Screenshot
    END

*** Keywords ***

Take Embedded Screenshot
    Take Screenshot  EMBED  fileType=png  fullPage=True