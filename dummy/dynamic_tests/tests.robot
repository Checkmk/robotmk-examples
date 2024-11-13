*** Settings ***

Documentation  This suite demonstrates the use of a dynamic test listener
...  to create a test suite with a variable number of test cases
Library  ./DynamicTestListener.py

*** Variables ***

${NUMBER_OF_TESTS}  3

*** Test Cases ***

# One Test is required in a vaölid suite file; "Dummy" gets deleted by the listener
Dummy
   No Operation