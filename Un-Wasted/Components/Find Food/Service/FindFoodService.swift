//
//  FindFoodService.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol FindFoodServiceType {
    func loadFoodNearby(location lat: Double, long: Double, success: @escaping ([FoodItem]) -> (), failure: () -> ())
    
    func biteFood(foodItem item: FoodItem, success: @escaping () -> (), failure: @escaping (NetworkError) -> ())
}

class FindFoodService: FindFoodServiceType {
    
    func loadFoodNearby(location lat: Double, long: Double, success: @escaping ([FoodItem]) -> (), failure: () -> ()) {
        let endpoint = URL(string: "https://un-wasted.herokuapp.com/find-food")!
        
        URLSession.shared.dataTask(with: endpoint) { data, response, error in
            let json = JSON(data)
            
            let foodItems = json.array?.flatMap({ FoodItem(json: $0) })
            
            success(foodItems ?? [])
            
        }.resume()
    }
    
    func biteFood(foodItem item: FoodItem, success: @escaping () -> (), failure: @escaping (NetworkError) -> ()) {
        var request = URLRequest(url: URL(string: "https://un-wasted.herokuapp.com/bite-it")!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: item.toDictionary, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error == nil {
                    success()
                }
                else {
                    failure(NetworkError(error: error!))
                }
            }
        }.resume()
    }
}

