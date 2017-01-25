//
//  SurflineDataUtils.swift
//  Surf Map
//
//  Created by Patrick Woo-Sam on 1/25/17.
//  Copyright © 2017 Patrick Woo-Sam. All rights reserved.
//

import Foundation

extension String {
    // Copied from http://stackoverflow.com/questions/27880650/swift-extract-regex-matches by Mike Chirico
    func regex (pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
            let nsstr = self as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : [String] = [String]()
            regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: all) {
                (result : NSTextCheckingResult?, _, _) in
                if let r = result {
                    let result = nsstr.substring(with: r.range) as String
                    matches.append(result)
                }
            }
            return matches
        } catch {
            return [String]()
        }
    }
}

class SurflineDataPoints {
    let allCoordinates: [Int: (Double, Double)]

    class func get_all_coordinates() -> [Int: (Double, Double)] {
        var coordinateDict = [Int: (Double, Double)]()
        let rePattern = "([-.0-9]+)"
        if let path = Bundle.main.path(forResource: "spot_id_coordinates", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                for line in lines {
                    let matches = line.regex(pattern: rePattern)
                    if !matches.isEmpty {
                        let surf_id = Int(matches[0])
                        let latitude = Double(matches[1])
                        let longitude = Double(matches[2])
                        coordinateDict.updateValue((latitude!, longitude!), forKey: surf_id!)
                    }
                }
            } catch {
                print(error)
            }
        }
        return coordinateDict
    }
    
    init(allCoordinates: [Int: (Double, Double)]) {
        self.allCoordinates = SurflineDataPoints.get_all_coordinates()
    }
    
    // TODO: write function that returns only the data points which are in view.

}
