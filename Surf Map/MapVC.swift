//
//  MapVC.swift
//  Surf Map
//
//  Created by Patrick Woo-Sam on 1/23/17.
//  Copyright © 2017 Patrick Woo-Sam. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController, GMSMapViewDelegate {

    @IBOutlet var mapView_: GMSMapView!

    let surflineData = SurflineDataPoints(allCoordinates: SurflineDataPoints.get_all_coordinates())
    var surfData: SurfData = SurfData()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 12.0

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display
        // Santa Barbara, California with some zoom.
        let camera = GMSCameraPosition.camera(withLatitude: 34.4133, longitude: -119.8610, zoom: self.zoomLevel)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        self.view = mapView
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        for (id, (lat, long)) in self.surfData.coordinates {
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let surfSpot = GMSMarker(position: position)
            surfSpot.title = surfData.SB_spot_names_by_id[id]
            surfSpot.icon = surfData.marker_image(id: id, day_index: 0, time_index: 1)
            surfSpot.map = mapView
        }
    }
}
