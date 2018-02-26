//
//  HomeTabBarController.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers = [
            ProfileViewController.initalize(),
            FindFoodViewController.initalize(),
            PublicFeedViewController.initalize()
        ]
        
        self.viewControllers = viewControllers
        self.selectedIndex = 1
        
        self.tabBar.tintColor = UIColor.wastedGreen
        self.tabBar.backgroundColor = UIColor.white
        
        let centerTabImageView = findCenterTabImageView()
        
        let backgroundLayer = CAShapeLayer()
        let layerSize = CGSize(width: centerTabImageView.bounds.width + 40, height: centerTabImageView.bounds.height + 40)
        
        backgroundLayer.frame = CGRect(origin: CGPoint(x: (self.view.bounds.width * 0.5) - (layerSize.width * 0.5), y: -10), size: layerSize)
        backgroundLayer.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0).cgColor
        
        backgroundLayer.cornerRadius = layerSize.width * 0.5
        backgroundLayer.masksToBounds = true
        
        self.tabBar.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    private func findCenterTabImageView() -> UIImageView {
        let centerItemView = self.tabBar.subviews[1]
        
        return centerItemView.subviews.first as! UIImageView
    }
}
