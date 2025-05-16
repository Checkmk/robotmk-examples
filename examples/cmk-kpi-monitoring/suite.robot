*** Settings ***

Documentation       A test suite which demonstrates how to flag certain Robot Framework
...   Keywords as KPIs which are then discovered in Checkmk as separate services. 
...   For this, the keyword Monitor Subsequent Keyword Runtime is used.
...   The argument discover_as is used to override the default service name in order to 
...   give them a number prefix for better sorting in Checkmk.
Library       random
Library       RobotmkLibrary

*** Test Cases ***

Flight Booking Functionality
    Monitor Subsequent Keyword Runtime  discover_as=1. Search Flight
    Search Flight
    Monitor Subsequent Keyword Runtime  discover_as=2. Book Flight
    Book Flight
    Monitor Subsequent Keyword Runtime  discover_as=3. Confirm Flight
    Confirm Flight

*** Keywords ***

Search Flight
    Random Sleep    1    3

Book Flight
    Random Sleep    1    3

Confirm Flight
    Random Sleep    1    3

Random Sleep
    [Arguments]   ${sec1}  ${sec2}
    ${randomWait}=    Evaluate    random.uniform(${sec1},${sec2})    random
    Sleep    ${randomWait}