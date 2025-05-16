*** Settings ***
Documentation       This suite shows how three libraries work together smoothly:
...                 Browser Library for the web-based part of the test,
...                 CryptoLibrary for decrypting the secrets,
...                 and a tiny self-written keyword, based on the pyotp library that generates the one-time token.

Library             Browser
Library             ./totp.py

Suite Setup         New Browser    browser=${BROWSER}    headless=${HEADLESS}
Suite Teardown      Close Browser
Test Setup          New Context
Test Teardown       Close Context


*** Variables ***
${BROWSER}      chromium
${HEADLESS}     False
${USERNAME}     demo_user
${PASSWORD}     secret_pass
${SECRET}       GAXG2MTEOR3DMMDG


*** Test Cases ***
Login with MFA
    New Context  tracing=trace.zip
    New Page    https://seleniumbase.io/realworld/login
    Fill Text    id=username    ${USERNAME}
    Fill Text    id=password    ${PASSWORD}
    ${totp}    Get Totp    ${SECRET}
    Fill Text    id=totpcode    ${totp}
    Click    "Sign in"
    Get Text    h1    ==    Welcome!
