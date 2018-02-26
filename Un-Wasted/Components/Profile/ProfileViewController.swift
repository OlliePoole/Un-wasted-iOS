//
//  ProfileViewController.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak private var profileImageView: UIImageView!
    @IBOutlet weak private var profileNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContent()
    }
    
    private func loadContent() {
        profileImageView.sd_setImage(with: UserManager.currentUser.imageURL)
        
        let attributedString = NSMutableAttributedString(string: "\(UserManager.currentUser.name.uppercased())'S ",
            attributes: [
                NSAttributedStringKey.foregroundColor: UIColor.wastedGreen
            ])
        
        attributedString.append(NSMutableAttributedString(string: "PROFILE",
                                                          attributes: [
                                                            NSAttributedStringKey.foregroundColor: UIColor.black
            ]))
        
        profileNameLabel.attributedText = attributedString
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction private func addNewListingButtonPressed(sender: UIButton) {
        let addNewFoodViewController = AddFoodItemViewController.initalize()
        
        self.present(addNewFoodViewController, animated: true, completion: nil)
    }
    
    @IBAction private func logoutButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "Swap User", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Ollie", style: .default, handler: { _ in
            UserManager.currentUser = UserManager.userOne
            self.loadContent()
        }))
        
        alertController.addAction(UIAlertAction(title: "Alicia", style: .default, handler: { _ in
            UserManager.currentUser = UserManager.userTwo
            self.loadContent()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}
