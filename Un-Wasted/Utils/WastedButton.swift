//
//  WastedButton.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit

class WastedButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        // we unfortunatly need to add this here as well as the `enabled` override is not called on load
        backgroundColor = isEnabled == true ? UIColor.wastedGreen : UIColor(white: 0.83, alpha: 1.0)
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        setTitleColor(UIColor.white, for: .normal)
    }
    
}
