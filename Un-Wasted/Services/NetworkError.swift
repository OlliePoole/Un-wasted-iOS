//
//  NetworkError.swift
//  DutchCourage
//
//  Created by Oliver Poole on 09/07/2017.
//
//

import Foundation

struct NetworkError: Error {
    
    var code: Int
    var title: String
    var message: String
    
    init(code: Int, title: String, message: String) {
        self.code = code
        self.title = title
        self.message = message
    }
    
    init(error: Error) {
        self.code = 0
        self.title = ""
        self.message = error.localizedDescription
    }
    
    var errorDescription: String {
        return title + ": " + message
    }
}

extension NetworkError: Equatable {  }

func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
    return lhs.code == rhs.code && lhs.title == rhs.title && lhs.message == rhs.message
}


extension NetworkError {
    
    @nonobjc static let GeneralError = NetworkError(code: 1003, title: "Something went wrong there", message: "Please try again")
    
    @nonobjc static let UserCancelled = NetworkError(code: 1004, title: "User Cancelled", message: "")
}
