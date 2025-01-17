*** Test Cases ***
# Example
Grouping Keywords Example
    GROUP    Open browser to login page
        Log  Open Browser
        Log  Title Should Be Login Page
    END
    GROUP    Submit credentials
        Log  Input Username
        Log  Input Password
        Log  Click Button 
    END
    GROUP    Login should have succeeded
        Log  Title Should Be Welcome Page
    END

# Special cases
Anonymous group
    GROUP
        Log    Group name is optional.
    END

Nested Groups
    GROUP
        GROUP    Nested group
            Log    Groups can be nested.
        END
        IF    True
            GROUP
                Log    Groups can also be nested with other control structures.
            END
        END
    END

Failing group
    GROUP
        Fail  This group will fail.
        Log    Group name is optional.
    END