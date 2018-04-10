//
//  SMSEngineViewController.swift
//  SOSMessaging
//
//  Created by Angie Mugo on 10/04/2018.
//  Copyright © 2018 Angie Mugo. All rights reserved.
//
import UIKit
import Foundation
import Alamofire

class SMSEngineViewController: UIViewController, LocationManagerViewControllerDelegate {

    var messageText: String = "Help! I am in trouble."
    var contactNumber: String = "+254702200126"

    @IBAction func buttonTapped(_ sender: Any) {
        segueToLocation()
    }

    func segueToLocation() {
        let locationManager = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationManagerViewController") as! LocationManagerViewController
        locationManager.messageText = messageText
        locationManager.numberText = contactNumber
        locationManager.delegate = self
        self.present(locationManager, animated: true, completion: nil)
    }

    func sendSMS(_ myLocation: String) {
        let parameters: Parameters = [
            "To": contactNumber,
            "Body": messageText + myLocation
        ]

        Alamofire.request("https://c2e2efb0.ngrok.io/sms", method: .post, parameters: parameters)
            .responseJSON{
                response in
                guard response.result.isSuccess else {
                    print("Error while sending message: \(String(describing: response.result.error))")
                    return
                }
                print("success")
        }
    }
    }
