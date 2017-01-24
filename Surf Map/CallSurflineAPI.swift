//
//  CallSurflineAPI.swift
//  SurfMapMac
//
//  Created by Patrick Woo-Sam on 1/21/17.
//  Copyright © 2017 Patrick Woo-Sam. All rights reserved.
//

import Foundation
import Alamofire


class SurfData {
    let SB_spot_names_by_id = [4991: "Refugio", 4993: "El Capitan", 4994: "Sands", 4995: "Coal Oil Point",
                               4997: "Campus Point", 4990: "Leadbetter", 4998: "Sandspit",
                               139341: "Santa Barbara Harbor", 4999: "Hammond's",
                               5001: "Carpenteria State Beach", 5000: "Tarpits", 4197: "Rincon"]
    var dicts: Array<NSDictionary> = []
    var surf_max = [Int : [[Double]]]()
    var surf_min = [Int : [[Double]]]()
    var coordinates = [Int : (Double, Double)]()
    var wind_dir_speed = [Int : ([[Int]], [[Double]])]()

    init() {
        // Find all JSON for the beaches in SB and place data into self.dicts
        for id in SB_spot_names_by_id.keys {
            get_surfline_data(UInt32(id), surfdata: self)
        }
    }

    func add_data(_ data: NSDictionary) -> Void {
        let id = Int((data["id"] as! NSString).intValue)
        self.dicts.append(data)
        self.surf_max.updateValue(extract_Surf_data("surf_max", dict: data, surfdata: self), forKey: id)
        self.surf_min.updateValue(extract_Surf_data("surf_min", dict: data, surfdata: self), forKey: id)
        self.coordinates.updateValue(extract_lat_lon_data(data, surfdata: self), forKey: id)
        self.wind_dir_speed.updateValue(extract_wind_data(data, surfdata: self), forKey: id)
    }
}

func get_surfline_data(_ spot_id: UInt32, surfdata: SurfData) -> Void {
    let api_call: String = "https://api.surfline.com/v1/forecasts/\(spot_id)?"
    Alamofire.request(api_call).responseJSON { response in
        let JSON = response.result.value as! NSDictionary
        surfdata.add_data(JSON)
    }
}

func extract_Surf_data(_ dataKey: String, dict: NSDictionary, surfdata: SurfData) -> [[Double]] {
    /*
     Return Array of Arrays containing Floats.

     For surf_max as dataKey:
        dict[id][0] is an Array containing surf height in feet for today at 4am, 10am, 4pm, and 10pm.
        dict[id][1] is for the next day and so on.
     */
    let data_dict = dict["Surf"] as! NSDictionary
    let data = data_dict[dataKey] as! [[Double]]

    return data
}

func extract_lat_lon_data(_ dict: NSDictionary, surfdata: SurfData) -> (Double, Double) {
    let lat = (dict["lat"] as! NSString).doubleValue
    let lon = (dict["lon"] as! NSString).doubleValue

    return (lat, lon)
}

func extract_wind_data(_ dict: NSDictionary, surfdata: SurfData) -> ([[Int]], [[Double]]) {
    let data_dict = dict["Wind"] as! NSDictionary
    let wind_direction = data_dict["wind_direction"] as! [[Int]]
    let wind_speed = data_dict["wind_speed"] as! [[Double]]

    return (wind_direction, wind_speed)
}
