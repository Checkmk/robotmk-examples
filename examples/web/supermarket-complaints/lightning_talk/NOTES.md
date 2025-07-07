## 00.robot

this is a Web Test => Import Browser library 
Create Browser instance with visible UI
```
Library  Browser
Suite Setup   New Browser  headless=${HEADLESS}
```
## 01.robot

Create the Test Cases: 

- `Create Complaint`  
- `Search Complaint` 
- add "No Operation" kwd to both test cases

Define test Setup: create a new page for each test
- Test 1: `[Setup]  New Page  ${URL}`
- Test 2: `[Setup]  New Page  ${URL}/mailbox`
- Define the Variable in Var section: `${URL}       https://supermarket-complaints.demo.robotmk.org/`

## 02.robot

Define the basic steps on the highest keyword level (only test logic, no implementation!)

Create Complaint : 
    Submit Form
    Save Complaint ID
02: 
    Login   agent   ${TEST_TOKEN}
    Search Complaint  ${REQUEST_ID}

=> Quick Fix  => legt Argument an!

## 03 Create Complaint

Submit Form:
```
    Fill Text  id=subject  Temperature
    Fill Text  id=message  It's too cold in your store!
    Fill Text  id=city  Munich
    Fill Text  id=token  ${TEST_TOKEN}
    Click  id=submit-btn
```

Save Complaint ID: 
- Auslesen eines Werts in Variable
```
    ${id}=   Get Text  id=request-id
    VAR  ${REQUEST_ID}  ${id}   scope=suite
    Sleep  2
```

## 04 Search complaint
Breakpoint
args umbenennen 

Login: 
```
    Fill Text  id=username  ${username}
    Fill Text  id=password  ${password}
    Click  id=login-btn
```
Search Complaint: 
```
    Fill Text  id=filter  ${arg1}
    Click  id=search
    Get Text  id=results  contains  ${request_id}  msg=Request {expected} not found!
```

