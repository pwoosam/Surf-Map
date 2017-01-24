//
//  MapVC.swift
//  Surf Map
//
//  Created by Patrick Woo-Sam on 1/23/17.
//  Copyright © 2017 Patrick Woo-Sam. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController {

    @IBOutlet var mapView_: GMSMapView!

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 12.0

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display
        // Santa Barbara, California with some zoom.
        let camera = GMSCameraPosition.camera(withLatitude: 34.4133, longitude: -119.8610, zoom: self.zoomLevel)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.view = mapView
    }
}
