
//
//  LocationManager.swift
//  SOSButton
//
//  Created by Angie Mugo on 13/03/2018.
//  Copyright © 2018 Angie Mugo. All rights reserved.
//
import GoogleMaps
import UIKit

protocol LocationManagerViewControllerDelegate: class {
    func setLocation()
}

class LocationManager: UIViewController, CLLocationManagerDelegate {

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 6.0)
            mapView.camera = camera
            showMarker(position: camera.target)
        }
    }

    func showMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        let markerImage = UIImage(named: "UserLocation")?.withRenderingMode(.alwaysTemplate)

        let markerView = UIImageView(image: markerImage)

        markerView.tintColor = UIColor.red

        marker.position = position
        marker.title = "Palo Alto"
        marker.snippet = "San Francisco"
        marker.map = mapView
        marker.iconView = markerView

        mapView.selectedMarker = marker

    }
}

extension LocationManager: GMSMapViewDelegate {

    //MARK: GMSMarker info window
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("did tap info window")
    }

    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("did long press info window")
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6

        let label1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        label1.text = "Hi there"
        view.addSubview(label1)

        let label2 = UILabel(frame: CGRect.init(x: label1.frame.origin.x, y: label1.frame.origin.y, width: view.frame.size.width - 16, height: 15))
        label2.text = "I am a custom info window"
        label2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(label2)

        return view
    }

    //MARK: GMSMarker position

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coordinate
    }

    //MARK: Marker Icon




}


