//
//  FoodItem.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation
import CoreLocation

struct FoodItem {
    let name: String
    let description: String
    let expiry: Date
    
    let imageURL: URL
    let distance: Double
    
    let provider: User
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
    
}
