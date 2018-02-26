//
//  AddFoodService.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation
import Alamofire

protocol AddFoodServiceType {
    func createFoodItem(name: String, imageURL: String, expiry: String, location: CLLocationCoordinate2D, provider: User, success: @escaping () -> (), failure: @escaping (NetworkError) -> ())
}

class AddFoodService: AddFoodServiceType {
    
    func createFoodItem(name: String, imageURL: String, expiry: String, location: CLLocationCoordinate2D, provider: User, success: @escaping () -> (), failure: @escaping (NetworkError) -> ()) {
        
        var url = URLRequest(url: URL(string: "https://un-wasted.herokuapp.com/add-food-item")!)
        url.httpMethod = "POST"
        
        let jsonData: [String: Any] = [
            "name": name,
            "imageURL": imageURL,
            "expiry": expiry,
            "location": [
                "lat": location.latitude,
                "lng": location.longitude
            ],
            "provider": [
                "name": provider.name,
                "image": provider.imageURL.absoluteString,
                "apns_token": ""
            ]
        ]
        
        url.addValue("application/json", forHTTPHeaderField: "Content-Type")
        url.httpBody = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error == nil {
                success()
            }
            else {
                failure(NetworkError(error: error!))
            }
            
        }.resume()
    }
    
}

