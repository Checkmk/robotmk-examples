*** Settings ***
Documentation  This suite demonstrates the use of a custom library.
...  The Keyword "Add Numbers" is defined in the custom library
...  by a Python function.
Library  CustomLibrary.py

*** Test Cases ***

Test Hello 
    Say Hello  Robots

Test Addition
    ${result}=  Add Numbers  44  11
    Log  ${result}