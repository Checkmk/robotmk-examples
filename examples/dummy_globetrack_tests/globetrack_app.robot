*** Settings ***

Documentation       GlobeTrack is a fake application. This suite just produces
...  a lot of services in Checkmk.  
...  It requires psutils to be installed to align the sleep time with the CPU 
...  load to get more realistic results.

Library       random

*** Test Cases ***
Validate Expense Submission
    Open Expense Submission Page
    Fill In Expense Form With Valid Data
    Submit Expense Form Successfully

Flight Booking Functionality
    Open Flight Booking Page
    Enter Valid Flight Search Criteria
    Book Selected Flight Successfully

Password Reset Form
    Open Password Reset Page
    Request Password Reset With Registered Email
    Verify Password Reset Email Sent

Multi-Currency Expense Reporting
    Open Expense Reporting Module
    Select Multiple Currencies For Report
    Generate Multi-Currency Report Successfully

Travel Itinerary Generation
    Open Travel Planner
    Add Multiple Trip Segments
    Generate Final Itinerary PDF

User Role Access Control
    Open User Management Panel
    Assign Role To User
    Verify Access Based On Role


*** Keywords ***
Open Expense Submission Page
    CPU Random Sleep    1  2

Fill In Expense Form With Valid Data
    CPU Random Sleep    2  3

Submit Expense Form Successfully
    CPU Random Sleep    1  2

Open Flight Booking Page
    CPU Random Sleep    2  4

Enter Valid Flight Search Criteria
    CPU Random Sleep    2  4

Book Selected Flight Successfully
    CPU Random Sleep    2  4

Open Password Reset Page
    CPU Random Sleep    3  4

Request Password Reset With Registered Email
    CPU Random Sleep    3  4

Verify Password Reset Email Sent
    CPU Random Sleep    3  4

Open Expense Reporting Module
    CPU Random Sleep    1  2

Select Multiple Currencies For Report
    CPU Random Sleep    1  2

Generate Multi-Currency Report Successfully
    CPU Random Sleep    1  2

Open Travel Planner
    CPU Random Sleep    1  4

Add Multiple Trip Segments
    CPU Random Sleep    1  4

Generate Final Itinerary PDF
    CPU Random Sleep    1  4

Open User Management Panel
    CPU Random Sleep    1  4

Assign Role To User
    CPU Random Sleep    1  4

Verify Access Based On Role
    CPU Random Sleep    1  4


*** Keywords ***

Random Sleep
    [Arguments]   ${sec1}  ${sec2}
    ${randomWait}=    Evaluate    random.uniform(${sec1},${sec2})    random
    Sleep    ${randomWait}

CPU Random Sleep 
    [Arguments]   ${sec1}  ${sec2}
    ${cpu_load}    Evaluate    psutil.cpu_percent(interval=1)    psutil
    ${base_sleep}    Evaluate    ${cpu_load} / 10
    ${random_addition}    Evaluate    random.uniform(${sec1},${sec2})    random
    ${total_sleep}    Evaluate    ${base_sleep} + ${random_addition}
    Sleep   ${total_sleep}