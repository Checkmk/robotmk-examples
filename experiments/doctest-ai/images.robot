*** Settings ***
Library    DocTest.Ai
Library    String

*** Variables ***
${YN_PROMPT_BASE}=    Look at the provided image and evaluate the following statement: "<STATEMENT>". 
...    Respond exactly with 'Yes', if the statement is fully and unambiguously correct based on the image.
...    Respond exactly with 'No', if the statement is not fully correct, partially correct, not verifiable, or ambiguous. 
...    Respond with exactly one word only.

*** Test Cases ***
Verify Graph 1 Workday Seasonality
    ${result}=    Is Statement True In Image
    ...    On workdays (Monday–Friday), the graph shows a repeating daily pattern with higher values during daytime and lower values at night, and this pattern does not occur on Saturday or Sunday.  
    ...    img/graph1.png
    Should Be Equal As Strings    ${result}    Yes    ignore_case=True

Verify Graph 1 Contains No Spike On Sunday
    ${result}=    Is Statement True In Image
    ...    On Sunday, the graph shows no spikes — no sharp peaks or sudden rises are present.
    ...    img/graph1.png
    Should Be Equal As Strings    ${result}    Yes    ignore_case=True

Verify Graph 1 Has 4 Spikes
    ${result}=    Get Item Count From Image
    ...    item_description=Count the number of distinct high spikes in the graph on workdays (Monday–Friday) and return only the integer number with no other text.
    ...    document=img/graph1.png
    Should Be Equal As Integers    ${result}    4

Verify Graph 2 Is Continuous
    ${result}=    Is Statement True In Image
    ...    The graph shows a fully continuous, flat, high plateau with no spikes, peaks, dips, interruptions, or irregularities.
    ...    img/graph2.png
    Should Be Equal As Strings    ${result}    Yes    ignore_case=True


*** Keywords ***
Build Yes/No Prompt
    [Arguments]    ${statement}
    ${prompt}=    Replace String    ${YN_PROMPT_BASE}    <STATEMENT>    ${statement}
    RETURN    ${prompt}

Is Statement True In Image
    [Arguments]    ${statement}    ${image}
    ${prompt}=    Build Yes/No Prompt    ${statement}
    ${result}=    Chat With Document    prompt=${prompt}    documents=${image}
    RETURN      ${result}