## 00
- Web Test => Import Browser
- Suite Beginn: 
```
Library  Browser
Suite Setup   New Browser  headless=${HEADLESS}
```

## 01

Test Cases: 
- `Create Complaint` + No Operation
- `Search Complaint` + No Operation
test Setup:
- `[Setup]  New Page  ${URL}`
- Für Url Var section: `${URL}       https://supermarket-complaints.demo.robotmk.org/`
- Test case 1+2 (2: /mailbox)

## 02
Woraus bestehen die Test Cases? 
01: 
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

