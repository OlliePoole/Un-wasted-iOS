//
//  AddFoodItemViewController.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit
import MapKit

class AddFoodItemViewController: UIViewController {
    
    @IBOutlet weak private var addPhotoIconImageView: UIImageView!
    @IBOutlet weak private var itemImageView: UIImageView!
    
    @IBOutlet weak private var nameTextField: UITextField!
    
    @IBOutlet weak private var expiryDateLabel: UILabel!
    @IBOutlet weak private var locationMapView: MKMapView!
    
    @IBOutlet weak private var listItButton: UIButton!
    
    @IBOutlet weak private var loadingOverlayView: UIView!
    @IBOutlet weak private var loadingOverlayActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var loadingOverlayMessageLabel: UILabel!
    
    var viewModel: AddFoodItemViewModel!
    
    private var selectedImageURL: URL?
    private var selectedName: String?
    private var selectedExpiry: Date?
    private var selectedLocation: CLLocationCoordinate2D?
    
    var imageUploadLoadingStateMachine: LoadingStateMachine<URL> = .initial {
        didSet {
            switch imageUploadLoadingStateMachine {
            case let .loaded(results):
                selectedImageURL = results.first
                
            default:
                break
            }
        }
    }
    
    var createListingLoadingStateMachine: LoadingStateMachine<Bool> = .initial {
        didSet {
            switch createListingLoadingStateMachine {
            case .loading:
                
                UIView.animate(withDuration: 0.1) {
                    self.loadingOverlayView.alpha = 0.6
                }
                
            case .loaded:
                UIView.animate(withDuration: 0.2, animations: {
                    self.loadingOverlayActivityIndicator.alpha = 0
                    
                }, completion: { _ in
                    self.loadingOverlayMessageLabel.text = "All done - thank you!"
                    
                    wait(seconds: 2) {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddFoodItemViewModel(outputs: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        locationMapView.camera.altitude = 2000
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction private func cameraButtonPressed(sender: UIButton) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.allowsEditing = false
        imagePickerViewController.sourceType = .camera
        imagePickerViewController.delegate = self
        
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction private func expiryDateButtonPressed(sender: UIButton) {
        let expiryDateEntryViewController = ExpiryDateEntryViewController.initalize()
        
        expiryDateEntryViewController.onCompleted = { date in
            self.dismiss(animated: true, completion: nil)
            
            self.selectedExpiry = date
            self.expiryDateLabel.text = date.formatted()
        }
        
        present(expiryDateEntryViewController, animated: true, completion: nil)
    }
    
    @IBAction private func mapViewButtonPressed(sender: UIButton) {
        let locationPickerViewController = PickupLocationViewController.initalize()
        locationPickerViewController.selectedCoordinate = self.selectedLocation
        
        locationPickerViewController.onCompletion = { location in
            self.dismiss(animated: true, completion: nil)
            
            self.selectedLocation = location
            
            self.locationMapView.setCenter(location, animated: true)
            self.locationMapView.camera.altitude = 2000
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            self.locationMapView.addAnnotation(annotation)
        }
        
        present(locationPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction private func listItButtonPressed(sender: UIButton) {
        guard let imageURL = self.selectedImageURL,
            let name = self.nameTextField.text,
            let expiry = self.selectedExpiry?.shortFormatted(),
            let location = self.selectedLocation, !name.isEmpty && name != "" else {
                
                listItButton.shake(magnitude: .small)
                return
        }
        
        self.viewModel.inputs.createListing(imageURL: imageURL, itemName: name, expiryDate: expiry, location: location)
    }
    
    @IBAction private func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddFoodItemViewController: AddFoodItemViewModelOutputs {  }

extension AddFoodItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        viewModel.inputs.uploadImage(image: image)
        
        self.itemImageView.image = image
        self.addPhotoIconImageView.isHidden = true
    }
    
}

private extension Date {
    
    func formatted() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM"
        
        return formatter.string(from: self)
    }
    
    func shortFormatted() ->  String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
}
