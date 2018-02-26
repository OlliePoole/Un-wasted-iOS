//
//  FoodItem.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct FoodItem {
    let id: String
    let name: String
    let expiry: Date
    
    let imageURL: URL
    let distance: Double
    let location: CLLocationCoordinate2D
    
    let provider: User
    
    init?(json: JSON) {
        guard let id = json["_id"].string, let name = json["name"].string, let expiryString = json["expiry"].string, let expiry = Date(webString: expiryString), let imageURL = json["imageURL"].url, let locationLat = json["location"]["lat"].double, let locationLng = json["location"]["lng"].double, let provider = json.dictionary?["provider"].flatMap(User.init) else {
            
            return nil
        }
        
        if provider.name == UserManager.currentUser.name {
            return nil
        }
        
        self.id = id
        self.name = name
        self.expiry = expiry
        
        self.imageURL = imageURL
        self.distance = 0
        self.location = CLLocationCoordinate2D(latitude: locationLat, longitude: locationLng)
        self.provider = provider
    }
}

extension FoodItem: Equatable {
    static func ==(lhs: FoodItem, rhs: FoodItem) -> Bool {
        return lhs.name == rhs.name
    }
}

extension FoodItem {
    
    var expiryFormatted: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM"
        
        return formatter.string(from: expiry)
    }
    
    var distanceFormatted: String {
        let formatter = LengthFormatter()
        
        return formatter.string(fromMeters: distance)
    }
    
    var toDictionary: [String: Any] {
        return [
            "name": name,
            "imageURL": imageURL.absoluteString,
            "expiry": expiry.shortFormatted,
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
    }
    
}

private extension Date {
    
    init?(webString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: webString) {
            self.init(timeInterval:0, since:date)
        }
        else {
            return nil
        }
    }
    
    var shortFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
    
}
