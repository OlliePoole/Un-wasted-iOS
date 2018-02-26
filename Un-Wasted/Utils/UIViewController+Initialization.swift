//
//  UIViewController+Initialization.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func initalize() -> Self {
        return initalizeFromStoryboard(name: String(describing: self))
    }
    
    private class func initalizeFromStoryboard<T>(name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        return storyboard.instantiateInitialViewController() as! T
    }
    
}
