*** Settings ***
Library    RequestsLibrary
Documentation    This is a test suite for the RequestsLibrary which connects
...  to the github.com API and retrieves user information.

*** Test Cases ***
Example with RequestsLibrary
    # Connect to the GitHub API and create a session
    Create Session    github    https://api.github.com
    # Read user information
    ${resp}    GET On Session    github    /users/octocat
    # Validate the response
    Should Be Equal As Strings    ${resp.status_code}    200
    # Convert the response to a JSON object 
    VAR  ${json}   ${resp.json()}
    # Do more assertions
    Should Be Equal As Strings    ${json["login"]}    octocat
    Should Be Equal As Strings    ${json["type"]}    User
    Should Be Equal As Strings    ${json["name"]}    The Octocat
    Should Be Equal As Strings    ${json["blog"]}    https://github.blog
    Should Be Equal As Strings    ${json["location"]}    San Francisco
