//
//  User.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let name: String
    let imageURL: URL
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
