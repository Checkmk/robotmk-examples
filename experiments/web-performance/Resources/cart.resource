*** Settings ***
Library           Browser  run_on_failure=Take Screenshot \ EMBED
Resource          common.resource

*** Keywords ***
Open Cart
    Click          data-test=nav-cart
    FOR  ${item}  IN  @{ITEMS_TO_ADD}
        Wait For Condition  Text   app-cart  contains  ${item}   msg=Item '${item}' not found in cart
    END
    common.Take A Screenshot   app-cart