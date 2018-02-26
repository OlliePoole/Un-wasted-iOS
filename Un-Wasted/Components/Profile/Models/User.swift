//
//  User.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    let name: String
    let imageURL: URL
    
    var apnsToken: String?
    var publicKey: String!
    
    init?(json: JSON) {
        guard let name = json["name"].string, let image = json["image"].url else {
            return nil
        }
        
        self.name = name
        self.imageURL = image
        self.apnsToken = json["apns_token"].string
    }
    
    init(name: String, imageURL: URL, apnsToken: String, publicKey: String) {
        self.name = name
        self.imageURL = imageURL
        self.apnsToken = apnsToken
        self.publicKey = publicKey
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
    }
}
