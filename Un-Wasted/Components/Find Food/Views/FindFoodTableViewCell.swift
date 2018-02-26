//
//  FindFoodTableViewCell.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit
import SDWebImage

class FindFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var foodImageView: UIImageView!
    
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var userImageView: UIImageView!
    
    @IBOutlet weak private var foodNameLabel: UILabel!
    @IBOutlet weak private var foodDistanceLabel: UILabel!
    
    func configure(foodItem: FoodItem) {
        foodImageView.sd_setImage(with: foodItem.imageURL)
        
        userNameLabel.text = foodItem.provider.name
        userImageView.sd_setImage(with: foodItem.provider.imageURL)
        
        foodNameLabel.text = foodItem.name.uppercased()
        foodDistanceLabel.text = foodItem.distanceFormatted
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width * 0.5
        userImageView.layer.masksToBounds = true
    }
}
