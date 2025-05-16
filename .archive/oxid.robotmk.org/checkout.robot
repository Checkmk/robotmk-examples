*** Settings ***
Documentation       This suite verifies that the checkout process shows the correct final price. 
Resource            webshop_oxid.resource
Library             Browser  
...    enable_presenter_mode={"duration": "0.5 seconds", "width": "4px", "style": "dotted", "color": "red"}
Test Setup          Open Webshop   

*** Variables ***
${BROWSER}      chromium
${ARTICLE_ID}  2402
${ARTICLE_TITLE}   Binding LIQUID FORCE TRANSIT BOOT
${ARTICLE_PRICE}   259,00 €

*** Test Cases ***
Search Item And Add To Basket
    [Documentation]    Searches an article, adds it to the basket and tries to navigate to the checkout page.
    [Teardown]  Take Screenshot  EMBED  selector=div#content
    Empty Basket
    Search And Select Article   
    ...    article_id=${ARTICLE_ID}
    ...    article_title=${ARTICLE_TITLE}
    ...    article_price=${ARTICLE_PRICE}
    Get Text  id=basketGrandTotal  *=  259,00 €  
    ...    msg=ERROR: Did not find the expected price ${ARTICLE_PRICE} for article ID ${ARTICLE_ID} (${ARTICLE_TITLE})!