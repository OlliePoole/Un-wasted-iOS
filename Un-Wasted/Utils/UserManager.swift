//
//  UserManager.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation

struct UserManager {
    
    static let userOne = User(name: "Ollie", imageURL: URL(string: "https://pbs.twimg.com/profile_images/747453039569739777/O2o7FbGM_400x400.jpg")!, apnsToken: "", publicKey: "")
    static let userTwo = User(name: "Alicia", imageURL: URL(string: "https://pbs.twimg.com/profile_images/573557270706982912/Ds6YAJdY_400x400.jpeg")!, apnsToken: "", publicKey: "")
    
    
    static var currentUser: User {
        get {
            let userName = UserDefaults.standard.string(forKey: "Saved_User")
            if userName == "Ollie" {
                return userOne
            }
            else {
                return userTwo
            }
        }
        set {
            UserDefaults.standard.set(newValue.name, forKey: "Saved_User")
        }
    }
    
}
