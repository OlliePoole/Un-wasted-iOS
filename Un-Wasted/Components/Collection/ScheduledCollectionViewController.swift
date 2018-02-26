//
//  ScheduledCollectionViewController.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 25/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit

class ScheduledCollectionViewController: UIViewController {
    
    @IBOutlet weak private var recipientImageView: UIImageView!
    @IBOutlet weak private var matchLabel: UILabel!
    
    @IBOutlet weak private var qrCodeImageView: UIImageView!
    
    var recipientImageURL: String!
    var recipientName: String!
    var matchText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageURL = URL(string: recipientImageURL) {
            recipientImageView.sd_setImage(with: imageURL)
        }
        
        self.matchLabel.text = matchText
        
        let qrCodeImage = generateQRCode(from: UserManager.currentUser.publicKey)
        
        qrCodeImageView.image = qrCodeImage
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        recipientImageView.layer.cornerRadius = recipientImageView.bounds.height
        recipientImageView.layer.masksToBounds = true
    }
    
    @IBAction private func doneButtonPressed(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

private extension ScheduledCollectionViewController {
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
}
