# Import modules
import requests
from urllib.request import urlparse, urljoin
from bs4 import BeautifulSoup
import colorama

# Initialise the set of links
Murls = set()

# Checks to see if the URL is valid
def isValid(url):
    parsed = urlparse(url)
    return bool(parsed.netloc) and bool(parsed.scheme)

# Returns all URLs that are found 
def getLinks(url):
    urls = set()
    domainName = urlparse(url).netloc
    soup = BeautifulSoup(requests.get(url).content, "html.parse")

    # Gets all 'a' anchor tags in the HTML
    for aTag in soup.findAll("a"):
        href = aTag.attrs.get("href")
        # If href is emtpy, go to next link
        if href == "" or href is None:
            continue

        # Joins urls together with domain name
        href = urljoin(url, href)

        # Remove HTTP GEt paranmeters from URLs
        hrefParsed = urlparse(href)
        href = hrefParsed.scheme + "://" + hrefParsed.netloc + hrefParsed.path

        # Check if URl is NOT valid
        if not isValid(href):
            continue
        
        # Check if URL is already in set
        if href in Murls:
            continue

        # Print the URLs found and see to set
        print(f"[*] Link: {href}")
        urls.add(href)

    # Return the set
    return urls

    if _name_ == "_main_":
        getLinks("http://www.cs.nuim.ie")
        print("[+] Total: ", urls)

