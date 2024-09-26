*** Settings ***
Documentation       Template robot main suite.

Library             Browser

Suite Setup         Suite Initialization


*** Variables ***
${URL}      https://marketsquare.github.io/robotframework-browser/Browser.html


*** Test Cases ***
Test Get Cell Element
    ${table}=    Set Variable    [id="Get Table Cell Element"] >> div.kw-docs table >> nth=1
    ${e}=    Get Table Cell Element    ${table}    "Real Name"    "aaltat"    # Returns element with text Tatu Aalto
    Get Text    ${e}    ==    Tatu Aalto
    ${e}=    Get Table Cell Element    ${table}    "Slack"    "Mikko Korpela"    # Returns element with text @mkorpela
    Get Text    ${e}    ==    @mkorpela
    # column does not need to be in row 0
    ${e}=    Get Table Cell Element
    ...    ${table}
    ...    "mkorpela"
    ...    "Kerkko Pelttari"
    Get Text    ${e}    ==    @mkorpela
    ${e}=    Get Table Cell Element    ${table}    2    -1    # Index is also directly possible
    Get Text    ${e}    ==    René Rohner

Test Get Table Row Index
    # Table of keyword Get Table Cell Element
    ${table}=    Set Variable
    ...    id=Get Table Cell Element >> div.kw-docs table
    ${idx}=    Get Table Row Index    ${table} >> "@René"
    Should Be Equal    ${idx}    ${4}
    Get Table Row Index    ${table} >> "@aaltat"    ==    2


*** Keywords ***
Suite Initialization
    New Browser    headless=${False}
    New Context    viewport=${None}
    New Page    url=${URL}
