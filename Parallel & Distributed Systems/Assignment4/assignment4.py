# Alan Lyne
# 15468498

# Import modules
import re
import requests
from urllib.request import urlparse, urljoin
from bs4 import BeautifulSoup
import colorama
import os

# Initialise the set of links
originalURL = "http://www.cs.nuim.ie"
Murls = set()
domainName = ""
string = "1"
# Checks to see if the URL is valid


def isValid(url):
    parsed = urlparse(url)
    return bool(parsed.netloc) and bool(parsed.scheme)


def getPage(urls):
    for url in urls:
        site = requests.get(url)
        writeHTML(site.text, url)


def writeHTML(data, url):
    dirName = originalURL.split('//')[1]

    # Create a new folder for each of out HTML pages that belong to our parent URL if it does not already exist.
    if not os.path.exists("Parallel & Distributed Systems//" + "Assignment4//" + "htmlFiles//" + dirName):
        os.mkdir("Parallel & Distributed Systems//" +
                 "Assignment4//" + "htmlFiles//" + dirName)

    # Saves our HTML we have found as a HTML file
    url = url.rsplit('/', 1)[-1]
    file = open("Parallel & Distributed Systems//" + "Assignment4//" +
                "htmlFiles//" + dirName + "//" + url + ".html", 'w', encoding='utf-8')
    file.write(data)


# Returns all URLs that are found
def getLinks(url):
    urls = set()
    domainName = urlparse(url).netloc
    soup = BeautifulSoup(requests.get(url).content, "html.parser")

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
        urls.add(href)

        f = open("url.html", "w")
        f.write(f"{href} \n")
        f.close

    # Return the set
    return urls


if __name__ == "__main__":
    urls = getLinks(originalURL)
    print("Number of URLs on " + originalURL + ": ", len(urls))
    getPage(urls)
