*** Settings ***
Documentation      This is a minimal Robot Framework suite for a Playwright based web test.
# Import the Browser Library
Library   Browser

*** Variables ***
# Define some variables

*** Test Cases ***
# One or more tets cases
My Test
    Open Browser   url=https://checkmk.com/de/guides/what-is-synthetic-monitoring
    Sleep  4

*** Keywords ***

# Here you can implement you own keywords
