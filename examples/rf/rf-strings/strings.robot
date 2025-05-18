*** Settings ***
Library    String
Documentation    This is a test suite for the String library.

*** Test Cases ***
Example with String
    VAR  ${string}    Hello, World!
    ${result}    Get Length    ${string}
    Should Start With    ${string}    Hel
    Should End With    ${string}    d!
    Should Not Contain    ${string}    Howdie