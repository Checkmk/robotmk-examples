from selenium import webdriver # type: ignore
from selenium.webdriver.common.by import By # type: ignore
from selenium.webdriver.common.keys import Keys # type: ignore # type: ignore
from selenium.webdriver.support.ui import WebDriverWait # type: ignore
from selenium.webdriver.support import expected_conditions as EC # type: ignore

# Configuration
url = "https://oxid.robotmk.org"
browser_type = "chromium"
article_id = "2402"
article_title = "Bindung LIQUID FORCE TRANSIT BOOT"
article_price = "259,00 €"

# Initialize WebDriver
driver = webdriver.Chrome()  # Use Chromedriver or the appropriate driver for your browser
driver.get(url)


def search_and_select_article():
    search_input = driver.find_element(By.ID, "searchParam")
    search_input.send_keys(article_id)
    search_input.send_keys(Keys.RETURN)
    
    # Wait for the search results to appear and select the first result
    WebDriverWait(driver, 10).until(
        EC.text_to_be_present_in_element((By.CSS_SELECTOR, "div.list-container div.row:first-child div.productData:first-child"), article_title)
    )
    first_result = driver.find_element(By.CSS_SELECTOR, "div.list-container div.row:first-child div.productData:first-child div.actions a")
    first_result.click()

    # Add to basket
    WebDriverWait(driver, 10).until(
        EC.visibility_of_element_located((By.ID, "toBasket"))
    ).click()

def check_basket():
    WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.CSS_SELECTOR, "a[title='Warenkorb zeigen']"))
    ).click()
    
    # Confirm the price in the basket
    basket_price = WebDriverWait(driver, 10).until(
        EC.visibility_of_element_located((By.ID, "basketGrandTotal"))
    ).text
    assert basket_price == article_price, f"ERROR: Did not find the expected price {article_price}"

def empty_basket():
    driver.find_element(By.CSS_SELECTOR, "text='Warenkorb'").click()
    WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.ID, "basketRemoveAll"))
    ).click()
    WebDriverWait(driver, 10).until(
        EC.visibility_of_element_located((By.ID, "empty-basket-warning"))
    )

if __name__ == "__main__":
    try:
        login()
        search_and_select_article()
        check_basket()
        empty_basket()
    finally:
        driver.quit()