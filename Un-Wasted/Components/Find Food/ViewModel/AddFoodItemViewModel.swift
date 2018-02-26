//
//  AddFoodItemViewModel.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit
import CoreLocation
import CryptoSwift

protocol AddFoodItemViewModelInputs: class {
    func uploadImage(image: UIImage)
    func createListing(imageURL: URL, itemName: String, expiryDate: String, location: CLLocationCoordinate2D)
}

protocol AddFoodItemViewModelOutputs: class {
    var imageUploadLoadingStateMachine: LoadingStateMachine<URL> { get set }
    var createListingLoadingStateMachine: LoadingStateMachine<Bool> { get set }
}

class AddFoodItemViewModel {
    
    private var imageUploadLoadingStateMachine: LoadingStateMachine<URL> = .initial {
        didSet {
            self.outputs?.imageUploadLoadingStateMachine = imageUploadLoadingStateMachine
        }
    }
    
    private var createListingLoadingStateMachine: LoadingStateMachine<Bool> = .initial {
        didSet {
            self.outputs?.createListingLoadingStateMachine = createListingLoadingStateMachine
        }
    }
    
    private let fileUploadService: FileUploadService
    private let createFoodService: AddFoodServiceType
    
    private (set) weak var outputs: AddFoodItemViewModelOutputs?
    var inputs: AddFoodItemViewModelInputs {
        return self
    }
    
    init(outputs: AddFoodItemViewModelOutputs, fileUploadService: FileUploadService = FileUploadService.shared, createFoodService: AddFoodServiceType = AddFoodService()) {
        self.outputs = outputs
        self.fileUploadService = fileUploadService
        self.createFoodService = createFoodService
    }
    
}

extension AddFoodItemViewModel: AddFoodItemViewModelInputs {
    
    func uploadImage(image: UIImage) {
        guard imageUploadLoadingStateMachine != .loading else {
            return
        }
        
        imageUploadLoadingStateMachine = .loading
        guard let imageData = UIImageJPEGRepresentation(image, 0.6) else {
            return
        }
        
        let upload = ImageUpload(data: imageData, uploadURL: URL(string: "https://vgy.me/upload")!, identifier: NSUUID().uuidString)
        fileUploadService.enqueue(upload: upload)
        
        fileUploadService.onSuccessfulUpload = { upload, response in
            guard let imageStringURL = response?["image"] as? String, let imageURL = URL(string: imageStringURL) else {
                return
            }
            
            self.imageUploadLoadingStateMachine = .loaded(items: [imageURL])
        }
        
        fileUploadService.onFailedUpload = { upload, error in
            self.imageUploadLoadingStateMachine = .error(error: NetworkError(error: error))
            }
    }
    
    func createListing(imageURL: URL, itemName: String, expiryDate: String, location: CLLocationCoordinate2D) {
        guard createListingLoadingStateMachine != .loading else {
            return
        }
        
        createListingLoadingStateMachine = .loading
        
        let randomNumber = arc4random()
        UserDefaults.standard.set(randomNumber, forKey: "random_number")
        
        let key = UserManager.currentUser.publicKey!
        
        //let concatenatedString = "\(randomNumber)" + key
        let concatenatedString = "0e6jxRNS0x60c6e6237c62923f7d63b1679f4a01dbc1b5339a"
        
        let hash = concatenatedString.sha3(.keccak256)
        
        createFoodService.createFoodItem(name: itemName, imageURL: imageURL.absoluteString, expiry: expiryDate, location: location, provider: UserManager.currentUser, success: {
            
            DispatchQueue.main.async {
                self.createListingLoadingStateMachine = .loaded(items: [true])
            }
        }) { error in
            DispatchQueue.main.async {
                self.createListingLoadingStateMachine = .error(error: error)
            }
        }
    }
}
