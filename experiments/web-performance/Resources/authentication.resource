*** Settings ***
Library           Browser  run_on_failure=Take Screenshot \ EMBED

*** Keywords ***
Login As User
    [Arguments]    ${email}    ${password}    ${name}
    Click          text=Sign in
    Fill Text      id=email     ${email}
    Fill Text      id=password  ${password}
    Click          data-test=login-submit
    Wait For Condition  Text  [role=menubar]  contains   ${name}  msg=User login failed; expected to find user name '${name}' in the top menu bar
