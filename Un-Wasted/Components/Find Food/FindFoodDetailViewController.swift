//
//  FindFoodDetailViewController.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit
import MapKit

class FindFoodDetailViewController: UIViewController {
    
    @IBOutlet weak private var foodItemImageView: UIImageView!
    @IBOutlet weak private var foodItemNameLabel: UILabel!
    
    @IBOutlet weak private var foodItemExpiryLabel: UILabel!
    
    @IBOutlet weak private var providerImageView: UIImageView!
    @IBOutlet weak private var providerNameLabel: UILabel!
    @IBOutlet weak private var providerDonationLevelLabel: UILabel!
    
    @IBOutlet weak private var mapView: MKMapView!
    
    @IBOutlet weak private var biteButton: UIButton!
    @IBOutlet weak private var biteButtonActivityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak private var scanButton: UIButton!
    
    var foodItem: FoodItem!
    var viewModel: FindFoodDetailViewModel!
    
    var biteLoadingStateMachine: LoadingStateMachine<Bool> = .initial {
        didSet {
            switch biteLoadingStateMachine {
            case .loading:
                biteButtonActivityIndicatorView.isHidden = false
                
            case .loaded:
                biteButtonActivityIndicatorView.isHidden = true
                
                let alertController = UIAlertController(title: "Great!", message: "You're all set", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                   self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertController, animated: true, completion: nil)
                
            default:
                break
            }
        }
    }
    
    var verifyLoadingStateMachine: LoadingStateMachine<Bool> = .initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = FindFoodDetailViewModel(outputs: self)
        
        foodItemImageView.sd_setImage(with: foodItem.imageURL)
        
        foodItemNameLabel.text = foodItem.name.uppercased()
        foodItemExpiryLabel.text = "Expires: \(foodItem.expiryFormatted ?? "")"
        
        providerImageView.sd_setImage(with: foodItem.provider.imageURL)
        providerNameLabel.text = foodItem.provider.name
        
        //providerDonationLevelLabel.text = NSLocalizedString("Pro Donator", comment: "")
        
        mapView.setCenter(foodItem.location, animated: true)
        mapView.camera.altitude = 2000
        mapView.delegate = self
        
        let circle = MKCircle(center: foodItem.location, radius: 300)
        mapView.add(circle)
        
        if LocalBiteStorage.shared.hasBeenPreviouslyBited(foodItem: foodItem) {
            biteButton.setTitle("BITTEN", for: .normal)
            biteButton.backgroundColor = UIColor.lightGray
            biteButton.isEnabled = false
            
            scanButton.layer.borderColor = UIColor.wastedGreen.cgColor
            scanButton.layer.borderWidth = 1
        }
        else {
            scanButton.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        providerImageView.layer.cornerRadius = providerImageView.bounds.height * 0.5
        providerImageView.layer.masksToBounds = true
    }
    
    @IBAction private func cancelButtonPressed(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func biteButtonPressed(sender: UIButton) {
        viewModel.inputs.bite(foodItem: self.foodItem)
    }
    
    @IBAction private func scanButtonPressed(sender: UIButton) {
        let scannerViewController = QRScannerViewController.initalize()
        
        scannerViewController.onSuccessfulRead = { code in
            self.viewModel.inputs.verifyBite(foodItem: self.foodItem, code: code)
        }
        
        present(scannerViewController, animated: true, completion: nil)
        
    }
}

extension FindFoodDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        
        circleView.strokeColor = UIColor.clear
        circleView.fillColor = UIColor.wastedGreen.withAlphaComponent(0.4)
        
        return circleView
    }
    
}

extension FindFoodDetailViewController: FindFoodDetailViewModelOutputs { }
