//
//  ExpiryDateEntryViewController.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit

class ExpiryDateEntryViewController: UIViewController {
    
    @IBOutlet weak private var datePicker: UIDatePicker!
    
    var onCompleted: ((_ date: Date) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date()
    }
    
    @IBAction private func doneButtonPressed(sender: UIButton) {
        let date = datePicker.date
        
        onCompleted(date)
    }
}
