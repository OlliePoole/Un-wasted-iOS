//
//  LocalBiteStorage.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 25/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation

class LocalBiteStorage {
    
    static let shared = LocalBiteStorage()
    
    private let key = "LocalBiteStorage.Bites"
    
    private init() {}
    
    func hasBeenPreviouslyBited(foodItem item: FoodItem) -> Bool {
        let localBits = UserDefaults.standard.array(forKey: key) as? [String]
        
        return localBits?.contains(item.id) ?? false
    }
    
    func registerBite(on item: FoodItem) {
        var localBits = UserDefaults.standard.array(forKey: key) as? [String]
        
        if localBits == nil {
            localBits = []
        }
        
        localBits?.append(item.id)
        
        UserDefaults.standard.set(localBits, forKey: key)
    }
    
}
