//
//  ImageUpload.swift
//  Doppels
//
//  Created by Oliver Poole on 19/09/2017.
//  Copyright © 2017 E-Man. All rights reserved.
//

import Foundation

class ImageUpload: Upload {
    
    private (set) var resourceData: Data
    private (set) var url: URL
    
    var identifier: String
    
    var uploadTask: URLSessionUploadTask?
    
    var mimeType: String {
        return "image/jpg"
    }
    
    var fileName: String {
        return "image1.jpg"
    }
    
    var fileParameterName: String = "file"
    
    var bytesSent: Float = 0
    var bytesExpected: Float = 0
    
    var uploadSuccessful: Bool?
    
    init(data: Data, uploadURL: URL, identifier: String) {
        self.url = uploadURL
        self.resourceData = data
        self.identifier = identifier
    }
    
    
}
