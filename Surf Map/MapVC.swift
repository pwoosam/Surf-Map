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
    var surfSpotMarkers = [GMSMarker]()
    var surfData: SurfData = SurfData()
    var mapView: GMSMapView!
    var zoomLevel: Float = 12.0
    private var currentLocContext = UnsafeMutableRawPointer(bitPattern: 0)

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display
        // Santa Barbara, California with some zoom.
        let camera = GMSCameraPosition.camera(withLatitude: 33.660057, longitude: -117.998970, zoom: self.zoomLevel)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        // self.mapView.settings.myLocationButton = true
        
        self.view = mapView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.addObserver(self, forKeyPath: "myLocation", options: [], context: self.currentLocContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == self.currentLocContext {
            let curLocation = self.mapView.myLocation!.coordinate
            let goCurrentLocation = GMSCameraUpdate.setTarget(curLocation)
            self.mapView.animate(with: goCurrentLocation)
            self.mapView.removeObserver(self, forKeyPath: keyPath!, context: context)
            self.currentLocContext?.deallocate(bytes: 0, alignedTo: 0)
            self.mapView.isMyLocationEnabled = false  // Save the CPU
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // Do not remove data from surfData, as this would increase data usage and put more load on Surfline's API.
        for (id, (lat, long)) in self.surflineData.allCoordinates {
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let visibleArea = mapView.projection.visibleRegion()
            let bounds = GMSCoordinateBounds(region: visibleArea)
            if !surfData.hasData(id) {
                if bounds.contains(position) {
                    self.surfData.get_surfline_data(id)
                } else {
                    // Skip adding this marker if it is not within the view.
                    continue
                }
            }
            if !surfData.hasData(id) {
                // Skip adding this marker if the data has not yet been received.
                continue
            }
            self.removeOutOfBoundsMarkers(bounds)
            let surfSpot = GMSMarker(position: position)
            surfSpot.title = self.surfData.spot_name[id]
            surfSpot.icon = self.surfData.marker_image(id: id, day_index: 0, time_index: 1)
            surfSpot.map = mapView
            self.surfSpotMarkers.append(surfSpot)
        }
    }
    
    private func removeOutOfBoundsMarkers(_ bounds: GMSCoordinateBounds) {
        var index = 0
        for marker in self.surfSpotMarkers {
            if !bounds.contains(marker.position) {
                marker.map = nil
                surfSpotMarkers.remove(at: index)
                index -= 1
            }
            index += 1
        }
    }
}
