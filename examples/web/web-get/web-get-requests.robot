*** Settings ***
Library    RequestsLibrary
Documentation    Example Robot Framework test case using RequestsLibrary to perform a GET request and validate the response.

*** Variables *** 

${URL}    https://sampleapp.tricentis.com/

*** Test Cases ***
Example with RequestsLibrary
    Create Session    alias=webpage    url=${URL} 
    
    ${resp}    GET On Session    webpage    /
    
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Contain    ${resp.text}    Welcome Aboard!
    Should Contain    ${resp.text}    Our Insane Insurance Offer
