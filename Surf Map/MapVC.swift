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
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        self.view = mapView
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // TODO: Loading too many spots causes high cpu and ram usage. Remove markers outside of mapView to fix cpu and ram usage.
        // Do not remove data from surfData, as this would increase data usage and put more load on Surfline's API.
        for (id, (lat, long)) in self.surflineData.allCoordinates {
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            if self.surfData.coordinates[id] == nil {
                let visibleArea = mapView.projection.visibleRegion()
                let bounds = GMSCoordinateBounds(region: visibleArea)
                if bounds.contains(position) {
                    self.surfData.get_surfline_data(id)
                } else {
                    continue
                }
            }
            if !surfData.has_data(id) {
                continue
            }
            let surfSpot = GMSMarker(position: position)
            surfSpot.title = self.surfData.spot_name[id]
            surfSpot.icon = self.surfData.marker_image(id: id, day_index: 0, time_index: 1)
            surfSpot.map = mapView
        }
    }
}
