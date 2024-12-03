*** Settings ***
Documentation       This suite shows how three libraries work together smoothly:
...                 Browser Library for the web-based part of the test,
...                 CryptoLibrary for decrypting the secrets,
...                 and a tiny self-written keyword, based on the pyotp library that generates the one-time token.

Library             Browser  enable_presenter_mode=True  show_keyword_call_banner=False
Library             ./totp.py
# Library    CryptoLibrary    password=%{RMK_CRYPTOLIB_ENV_VARIABLE}    variable_decryption=True    key_path=./keys
Library             CryptoLibrary    password=robotmk    variable_decryption=True    key_path=./keys

Suite Setup         New Browser    browser=${BROWSER}    headless=${HEADLESS}
Suite Teardown      Close Browser
Test Teardown       Close Context


*** Variables ***
${BROWSER}      chromium
${HEADLESS}     False
${USERNAME}     crypt:KVoHqyt/EZ9oW7IeYYIeh51DnOucuqoMOEZVBNXB8RJqzGaPOo08i84uqc/pRj7dHBRMtk+ltJMX
${PASSWORD}     crypt:NX7Ld7Y700rAOYVHJNRyZe/e+l9IdJebaGp2W1zw0Gs80KoP6Ra+owIy/PZ1Mo5lQyKQXiV/ZYENFvY=
${SECRET}       crypt:SkZ3GHK8qbMX1d538xGRUNq5pswtD08gG0QueBVc+R3brm1IqgAMrEu050luIh6AGqQbujX3EWwmRWZRyb01qw==


*** Test Cases ***
Login with MFA
    New Context  tracing=trace.zip  viewport={"width": 1280, "height": 720}
    New Page    https://seleniumbase.io/realworld/login
    Fill Text    id=username    ${USERNAME}
    Fill Text    id=password    ${PASSWORD}
    ${totp}    Get Totp    ${SECRET}
    Fill Text    id=totpcode    ${totp}
    Click    "Sign in"
    Get Text    h1    ==    Welcome!
