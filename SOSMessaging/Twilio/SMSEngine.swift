//
//  SMSEngine.swift
//  SOSMessaging
//
//  Created by Angie Mugo on 14/03/2018.
//  Copyright © 2018 Angie Mugo. All rights reserved.
//

import Foundation

protocol SMSEngineViewController: class {
    func setSOSNumber()
}

class SMSEngine {

    //TO DO - get location, send it together with the message when button is pressed

    func sendSMS() {
        let twilioSID = "AC0f40e6ca33ec1dd2b5b5ce3387650b94"
        let twilioSecret = "419b8455ce9ea878a1fa12aae92eb681"

        let fromNumber = "+14403067787-(440)306-7787"
        let toNumber = "+254702200126"
        let message = "Help I am in trouble"

        let request = NSMutableURLRequest(url: URL(string: "https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
        request.httpMethod = "POST"
        request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".data(using: String.Encoding.utf8)

        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            print("finished")
            if let data = data, let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                print("Response: \(response)")
            } else {
                print("Error: \(String(describing: error))")

            }

        }).resume()

    }
}

