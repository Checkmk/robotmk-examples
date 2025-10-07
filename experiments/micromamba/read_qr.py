import requests
from bs4 import BeautifulSoup
from PIL import Image
from pyzbar.pyzbar import decode
from io import BytesIO

def decode_qr_from_webpage():
    # URL of the target page
    url = "https://seleniumbase.io/realworld/signup"

    # Fetch the webpage content
    response = requests.get(url)
    response.raise_for_status()  # Raise an error if the request failed

    # Parse the HTML with BeautifulSoup
    soup = BeautifulSoup(response.text, 'html.parser')

    # Find the QR code image by its container's ID and extract the image source URL
    qr_image_element = soup.select_one("div#qrcode img")
    if not qr_image_element:
        print("QR code image not found on the page.")
        return None

    qr_image_url = qr_image_element["src"]

    # Handle relative URLs
    if not qr_image_url.startswith("http"):
        from urllib.parse import urljoin
        qr_image_url = urljoin(url, qr_image_url)

    # Download the QR code image
    qr_image_response = requests.get(qr_image_url)
    qr_image_response.raise_for_status()  # Ensure the image request was successful

    # Open the image and decode the QR code
    qr_image = Image.open(BytesIO(qr_image_response.content))
    decoded_objects = decode(qr_image)

    if decoded_objects:
        # Assuming there's one QR code in the image
        qr_data = decoded_objects[0].data.decode('utf-8')
        print("Decoded QR code data:", qr_data)
        return qr_data
    else:
        print("No QR code detected in the image.")
        return None

# Example usage
if __name__ == "__main__":
    decode_qr_from_webpage()
