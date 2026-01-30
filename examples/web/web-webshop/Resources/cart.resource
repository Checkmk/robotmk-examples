*** Settings ***
Library           Browser  run_on_failure=Take Screenshot \ EMBED


*** Keywords ***
Open Cart
    Click          data-test=nav-cart
    FOR  ${item}  IN  @{ITEMS_TO_ADD}
        Get Text   app-cart  contains  ${item}   msg=Item '${item}' not found in cart
    END
