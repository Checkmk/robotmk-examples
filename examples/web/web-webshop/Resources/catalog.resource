*** Settings ***
Library           Browser  run_on_failure=Take Screenshot \ EMBED

*** Keywords ***
Add Product To Cart
    [Arguments]    ${product_name}
    
    Click   text=Home
    Fill Text  data-test=search-query    ${product_name}
    Keyboard Key  press   Enter
    Click   .card-body >> text="${product_name}"
    Click          text=Add to cart
    ${count}=    Evaluate    str(int(${ITEMS_IN_CART}) + 1)
    VAR   ${ITEMS_IN_CART}  ${count}  scope=SUITE  
    Get Text  data-test=cart-quantity  equals  ${ITEMS_IN_CART}
    

