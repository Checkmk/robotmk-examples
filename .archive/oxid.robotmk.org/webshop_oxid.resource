*** Settings *** 

*** Variables ***
${URL}                      https://oxid.robotmk.org/index.php?cl=start&lang=1
${USERNAME}                 mail@robotmk.org
${PASSWORD}                 crypt:bD22YdO6Om/M63SHz3clvZ4UKpEonuvUh0nO+vHymmFGWjzPveg+dSTFGlVRmSk7ZQQj7anvpBA=

# Login Selectors
${HOME_BARGAIN_HEADLINE}    div#boxwrapper_bargainItems h2
${MENU_BT_ANMELDEN1}        div.service-menu > button
${MENU_F_USERNAME}          input#loginEmail
${MENU_F_PASSWORD}          input#loginPasword
${MENU_BT_ANMELDEN2}        div.service-menu form button
${BANNER_BADLOGIN}          p#errorBadLogin
${MENU_BT_ACCOUNT}          div.service-menu > button

# Article Selectors
${ARTICLE_F_SEARCH}         input#searchParam
${ARTICLE_BT_SEARCH}        form.search button
${ARTICLE_FIRST_RESULT}     div.list-container div.row:first-child div.productData:first-child
${ARTICLE_LINK}             div.actions a
${ARTICLE_DETAIL_INFO}      div.detailsInfo
${BT_ADD_TO_BASKET}         button#toBasket
${BT_SHOW_BASKET}           a[title='Display cart']
${BASKET_TOTAL_SUM}         td#basketGrandTotal
${BT_BASKET}                text="Cart"
${BANNER_BASKET_EMPTY}      div#empty-basket-warning
${BASKET_BT_SELECTALL}      button#basketRemoveAll
${BASKET_BT_REMOVE}         button#basketRemove


*** Keywords ***
Login
    [Documentation]    Performs a login with the given username/password.
    ...    Depending on the expectfail parameter, an error or success is expected.
    [Arguments]    ${uname}    ${pwd}    ${expectfail}=False    
    Click    ${MENU_BT_ANMELDEN1}
    Fill text    ${MENU_F_USERNAME}    ${uname}
    Fill text    ${MENU_F_PASSWORD}    ${pwd}
    Click    ${MENU_BT_ANMELDEN2}
    IF    ${expectfail} == ${True}  
        Get Element States
        ...    ${BANNER_BADLOGIN} 
        ...    *=
        ...    visible   
        ...    message="Did not receive expected error after login attempt with invalid credentials!"
    ELSE
        Get Text    ${MENU_BT_ACCOUNT}    *=    Mein Konto    message="Login failed!"
    END    


Open Webshop  
    [Documentation]    Opens the web shop's landing page
    New Browser    browser=${BROWSER}    headless=False
    New Context    viewport={'width': 1280, 'height': 720}
    New Page    ${URL}
    Get text  ${HOME_BARGAIN_HEADLINE}  *=  Week's Special


Search And Select Article
    [Documentation]    Performans an article query and opens the first matching item.
    [Arguments]    ${article_id}    ${article_title}    ${article_price}
    Fill Text    ${ARTICLE_F_SEARCH}    ${article_id}  
    Click    ${ARTICLE_BT_SEARCH}
    Get Text
    ...    ${ARTICLE_FIRST_RESULT}
    ...    *=
    ...    ${article_title}
    ...    message=Article ${article_id} cannot be found!
    
    Click    ${ARTICLE_FIRST_RESULT} ${ARTICLE_LINK}
    Get Text    ${ARTICLE_DETAIL_INFO}    *=    ${article_title}    message=Article ${article_id} cannot be found!
    Click    ${BT_ADD_TO_BASKET}
    Click    ${BT_SHOW_BASKET}
    Get Text
    ...    ${BASKET_TOTAL_SUM}
    ...    ==
    ...    ${article_price}
    ...    message=Price for article ${article_id} is {value} (expected:{expected})!
     

Empty Basket
    [Documentation]    Removes all items from the basket. 
    Click    ${BT_BASKET}
    ${basket_is_empty}    Get Element States    ${BANNER_BASKET_EMPTY}    then    bool(value & visible)
    IF    not ${basket_is_empty}
        Click    ${BASKET_BT_SELECTALL}
        Click    ${BASKET_BT_REMOVE}
        Get Element States    ${BANNER_BASKET_EMPTY}    *=    visible    message=Basket could not be cleared!
    END
    Go To    ${URL}    