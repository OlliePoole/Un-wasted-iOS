//
//  PickupLocationViewController.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import MapKit

class PickupLocationViewController: UIViewController {
    
    @IBOutlet weak private var mapView: MKMapView!
    
    var onCompletion: ((CLLocationCoordinate2D) -> ())!
    var selectedCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(recognizer:)))
        self.mapView.addGestureRecognizer(gesture)
        
        if let coordinate = self.selectedCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            mapView.addAnnotation(annotation)
        }
    }
    
    @objc func tapGestureTapped(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        self.selectedCoordinate = coordinate
        if let annotation = mapView.annotations.first as? MKPointAnnotation {
            annotation.coordinate = coordinate
        }
        else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            mapView.addAnnotation(annotation)
        }
        
    }
    
    @IBAction private func doneButtonPressed(sender: UIButton) {
        guard let coordiante = selectedCoordinate else {
            return
        }
        
        onCompletion(coordiante)
    }
}
