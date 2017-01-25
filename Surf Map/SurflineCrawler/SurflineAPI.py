#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 24 15:41:22 2017

@author: patrick
"""

import requests
import re

class SurflineAPI():
    def __init__(self):
        self.api_url = 'https://api.surfline.com/v1/forecasts/'
        self.requests_ = []

    def resources_request(self, spot_id):
        """Return json containing only resource data for spot_id"""
        req = requests.get(self.api_url + str(spot_id) + '?&resources')
        return req

    def get_coordinates(self, response):
        """Return tuple containing latitude and longitude for spot_id"""
        data = response.json()
        latitude = float(data['lat'])
        longitude = float(data['lon'])
        return latitude, longitude

if __name__ == '__main__':
    def get_coordinates(ids, failed_ids=[]):
        for i, spot_id in enumerate(ids):
            req = api.resources_request(spot_id)
            if req:
                coordinate = api.get_coordinates(req)
                coordinates[spot_id] = coordinate
            else:
                print('Id {} failed'.format(spot_id))
                failed_ids.append(spot_id)
            print('{:.2f}% completed'.format((i + 1) / len(ids) * 100))
        if failed_ids:
            print(failed_ids)
            print('Retrying for {} failed ids'.format(len(failed_ids)))
            get_coordinates(failed_ids)


    id_re = re.compile('(.*): ([0-9]*)')
    api = SurflineAPI()
    spot_ids = []
    coordinates = {}

    with open('spot_ids.txt', 'r') as file:
        for line in file:
            *_, spot_id, _ = id_re.split(line)
            spot_ids.append(spot_id)

    get_coordinates(spot_ids)

    with open('spot_id_coordinates.txt', 'w+') as file_:
        for spot_id, (latitude, longitude) in coordinates.items():
            file_.write('{}: ({}, {})\n'.format(spot_id, latitude, longitude))
