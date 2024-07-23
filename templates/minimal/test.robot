*** Settings ***
Documentation      This is a minimal Robot Framework suite.
...  You can execute it with 
...  `robot test.robot`
...  or 
...  `robot --variable MYVAR:Hello test.robot`
...  Either use an existing python environment or use RCC (https://github.com/robocorp/rcc)
...  to create one: 
...  `rcc task shell`

*** Variables ***

${MYVAR}    Hello Checkmk!

*** Test Cases ***
My Test
    Log      ${MYVAR}
    Sleep    3
    Log      Done.
