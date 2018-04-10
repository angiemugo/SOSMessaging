//
//  LocationManagerViewController.swift
//  SOSMessaging
//
//  Created by Angie Mugo on 28/03/2018.
//  Copyright © 2018 Angie Mugo. All rights reserved.
//
import UIKit
import GoogleMaps

protocol LocationManagerViewControllerDelegate: class {
    func sendSMS(_ myLocation: String)
}

class LocationManagerViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    //MARK: Global Variables
    
    let locationManager = CLLocationManager()
    var messageText: String?
    var numberText: String?
    var myLocation: String?
    var delegate: LocationManagerViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        delegate?.sendSMS(myLocation!)
        addAlert()
    }

    
    //MARK: Location Manager Functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 6.0)
            mapView.camera = camera
            showMarker(position: camera.target)
            locationManager.stopUpdatingLocation()
            let myLatitude = location.coordinate.latitude
            let myLongitude = location.coordinate.longitude
            self.myLocation = "My location is: https://maps.google.com/?ll=\(myLatitude)" + "," + "\(myLongitude)"

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

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = UIColor.black
        activityIndicator.center = window.center
        window.addSubview(activityIndicator)

        let messageLabel = setupLabel(8, 8, UIFont.systemFont(ofSize: 14, weight: .heavy), UIColor.red)
        let numberLabel = setupLabel(messageLabel.frame.origin.x, messageLabel.frame.origin.y + messageLabel.frame.size.height, UIFont.systemFont(ofSize: 12), UIColor.black)
        let placeLabel = setupLabel(numberLabel.frame.origin.x, numberLabel.frame.origin.y + numberLabel.frame.size.height, UIFont.systemFont(ofSize: 12, weight: .heavy), UIColor.black)
        activityIndicator.startAnimating()

        let countryLabel = setupLabel(placeLabel.frame.origin.x, placeLabel.frame.origin.y + placeLabel.frame.size.height, UIFont.systemFont(ofSize: 12, weight: .heavy), UIColor.black)

        messageLabel.text = messageText
        numberLabel.text = numberText

        window.addSubview(messageLabel)
        window.addSubview(numberLabel)

        DispatchQueue.main.async {
            self.lookUpCurrentLocation{ (placemark) in
                placeLabel.text = "Your location: \((placemark?.thoroughfare)!)"
                countryLabel.text = (placemark?.locality)! + ", " + (placemark?.subAdministrativeArea)!
                activityIndicator.stopAnimating()

                window.addSubview(placeLabel)
                window.addSubview(countryLabel)
            }
        }
        return window
    }

    func setupLabel(_ xCoordinate: CGFloat, _ yCoordinate: CGFloat, _ textFont: UIFont, _ textColor: UIColor) -> UILabel {
        let label = UILabel(frame: CGRect(x: xCoordinate, y: yCoordinate, width: view.frame.size.width - 15, height: 20))
        label.font = textFont
        label.textColor = textColor
        return label
    }

    func addAlert() {
        let alert = UIAlertController(title: "SUCCESS", message: "Message sent successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
