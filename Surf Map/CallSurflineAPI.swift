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
            self.get_surfline_data(id)
        }
    }

    func get_surfline_data(_ spot_id: Int) -> Void {
        let api_call: String = "https://api.surfline.com/v1/forecasts/\(spot_id)?"
        Alamofire.request(api_call).responseJSON { response in
            let JSON = response.result.value as! NSDictionary
            self.add_data(JSON)
        }
    }

    private func add_data(_ data: NSDictionary) -> Void {
        let id = Int((data["id"] as! NSString).intValue)
        self.dicts.append(data)
        self.surf_max.updateValue(self.extract_Surf_data("surf_max", dict: data), forKey: id)
        self.surf_min.updateValue(self.extract_Surf_data("surf_min", dict: data), forKey: id)
        self.coordinates.updateValue(self.extract_lat_lon_data(data), forKey: id)
        self.wind_dir_speed.updateValue(self.extract_wind_data(data), forKey: id)
        print("Adding \(self.SB_spot_names_by_id[id]!) to surf data.")
    }

    private func extract_Surf_data(_ dataKey: String, dict: NSDictionary) -> [[Double]] {
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
    
    private func extract_lat_lon_data(_ dict: NSDictionary) -> (Double, Double) {
        let lat = (dict["lat"] as! NSString).doubleValue
        let lon = (dict["lon"] as! NSString).doubleValue
        
        return (lat, lon)
    }
    
    private func extract_wind_data(_ dict: NSDictionary) -> ([[Int]], [[Double]]) {
        let data_dict = dict["Wind"] as! NSDictionary
        let wind_direction = data_dict["wind_direction"] as! [[Int]]
        let wind_speed = data_dict["wind_speed"] as! [[Double]]
        
        return (wind_direction, wind_speed)
    }
    
    public func marker_image(id: Int, day_index: Int, time_index: Int) -> UIImage {
        let max: Double = self.surf_max[id]![day_index][time_index]
        let min: Double = self.surf_min[id]![day_index][time_index]
        let size: Double = (max + min) / 2
        var img: UIImage
        if size < 2.0 {
             img = #imageLiteral(resourceName: "water_drop")
        } else if size < 4.0 {
            img = #imageLiteral(resourceName: "triple_drop")
        } else {
            img = #imageLiteral(resourceName: "wave")
        }
        return img.resizedImage(newSize: CGSize(width: 26, height: 26))
    }
}
