*** Settings ***
Documentation      This is a minimal Robot Framework suite.
...  You can execute it with 
...  `robot test.robot`
...  or 
...  `robot --variable MYVAR:Hello test.robot`
...  Either use an existing python environment or use RCC (https://github.com/robocorp/rcc)
...  to create one: 
...  `rcc task shell`

Library   utils.py
Variables  cfg.py

*** Variables ***

${MYVAR}    Hello Checkmk!

*** Test Cases ***
My Test
    Log To Console      ${MYVAR}
    My Log  msg=This is normal text. 
    My Log  msg=This is <b>bold</b> text. 
    Sleep    3
    Log      Done.
    VAR  ${car}  suv
    VAR  ${direction}  up
    VAR  ${keyword}  ${cfg}[${car}][${direction}]
    Run Keyword  ${keyword}


*** Keywords ***
yet another spaghetti
    Log  Mjam, spaghetti