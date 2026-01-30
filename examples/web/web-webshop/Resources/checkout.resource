*** Settings ***
Library           Browser  run_on_failure=Take Screenshot \ EMBED


*** Keywords ***
Open Checkout
    Click          text=Proceed to checkout
    Wait For Elements State    text=Checkout    visible


Checkout Page Should Be Visible
    Get Title    ==    Checkout
    Page Should Contain    Order summary
