//
//  LocationManagerViewController.swift
//  SOSMessaging
//
//  Created by Angie Mugo on 28/03/2018.
//  Copyright © 2018 Angie Mugo. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationManagerViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    //MARK: Global Variables
    
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    //MARK: Location Manager Functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 6.0)
            mapView.camera = camera
            showMarker(position: camera.target)
            locationManager.stopUpdatingLocation()
        }
    }
    
    //MARK: Get placemark names
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks![0]
                    completionHandler(firstLocation)
                } else {
                    completionHandler(nil)
                }
            })
        } else {
            completionHandler(nil)
        }
    }
    
    //MARK: GMSMarker info window
    
    func showMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        let markerImage = UIImage(named: "UserLocation")?.withRenderingMode(.alwaysTemplate)
        
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor.red
        
        marker.position = position
        marker.map = mapView
        marker.iconView = markerView
        marker.tracksInfoWindowChanges = true
        
        mapView.selectedMarker = marker
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let window = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        window.backgroundColor = UIColor.white
        window.layer.cornerRadius = 6
        return window
    }
}


