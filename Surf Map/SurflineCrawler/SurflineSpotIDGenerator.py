#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 24 14:37:26 2017

@author: patrick
"""

from bs4 import BeautifulSoup
import requests
import re

base = "https://www.surfline.com"
url = "https://www.surfline.com/surf-cams-and-reports/"
location_re = re.compile('/surf-report/|(.*)_([0-9]*)/map/')
spot_re = re.compile('/surf-report/|(.*)_([0-9]*)/')

response = requests.get(url)

soup = BeautifulSoup(response.content, 'html.parser')
links = soup.find_all(name='a', attrs={'href': location_re})

spot_ids = {}

for link in links:
    response = requests.get(base + link['href'])
    soup = BeautifulSoup(response.content, 'html.parser')
    spot_urls = soup.find_all(name='a', attrs={'href': spot_re})
    for spot_url in spot_urls:
        *_, loc, spot_id, _ = re.split(spot_re, spot_url['href'])
        spot_ids[loc] = spot_id

with open('spot_ids.txt', 'w+') as file:
    for spot, id_ in spot_ids.items():
        file.write('{}: {}\n'.format(spot, id_))
