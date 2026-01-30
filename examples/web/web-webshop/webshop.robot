*** Settings ***
Documentation     Synthetic monitoring demo – Checkout flow (no payment)
Library           Browser  run_on_failure=Take A Screenshot
# Use the CryptoLibrary to handle encrypted passwords; password for the private key is
# read from the environment; fallback (do not use in production!) is robotmk
Library           CryptoLibrary    
...    password=%{RF_CRYPT_PWD=robotmk}    
...    variable_decryption=True    
...    key_path=./keys
Resource          Resources/authentication.resource
Resource          Resources/catalog.resource
Resource          Resources/cart.resource
Resource          Resources/checkout.resource

Suite Setup       Open Webshop

*** Variables ***
${BASE_URL}       https://practicesoftwaretesting.com
${USER_EMAIL}     customer3@practicesoftwaretesting.com
${USER_PASSWORD}  crypt:+sGGKbSxC8zUzxUF/1Ag+WoUakwCqwRH/RiMDgbD21E607H4OrfLcBj0MKVpYDyrwq0So1WBOg==
${USER_NAME}      Bob Smith
${ITEMS_IN_CART}    0
@{ITEMS_TO_ADD}   Ear Protection    Safety Goggles

*** Test Cases ***
User Can Reach Checkout Page
    [Documentation]    Test if a logged-in user can add items to the cart.
    ...    Verify the cart items and perform the checkout.
    authentication.Login As User    ${USER_EMAIL}    ${USER_PASSWORD}  ${USER_NAME}
    catalog.Add Items To Cart       @{ITEMS_TO_ADD}
    cart.Open Cart
    checkout.Checkout
    
*** Keywords ***
Open Webshop
    New Browser    chromium    headless=%{ROBOTMK_HEADLESS_HOST=false}
    New Context  locale=en-US  viewport={ 'width': 1280, 'height': 1024 }
    New Page       ${BASE_URL}

Close Browser
    Close Browser

