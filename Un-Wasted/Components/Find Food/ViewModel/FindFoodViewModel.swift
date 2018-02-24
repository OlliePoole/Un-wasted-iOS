//
//  FindFoodViewModel.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation

protocol FindFoodViewModelInputs: class {
    func loadAvailableFood(location lat: Float, long: Float)
}

protocol FindFoodViewModelOutputs: class {
    var foodLoadingStateMachine: LoadingStateMachine<FoodItem> { get set }
}

class FindFoodViewModel {
    
    private var foodLoadingStateMachine: LoadingStateMachine<FoodItem> = .initial {
        didSet {
            self.outputs?.foodLoadingStateMachine = foodLoadingStateMachine
        }
    }
    
    private (set) weak var outputs: FindFoodViewModelOutputs?
    var inputs: FindFoodViewModel {
        return self
    }
    
    init(outputs: FindFoodViewModelOutputs) {
        self.outputs = outputs
    }
}

extension FindFoodViewModel: FindFoodViewModelInputs {
    
    func loadAvailableFood(location lat: Float, long: Float) {
        guard foodLoadingStateMachine != .loading else {
            return
        }
        
        foodLoadingStateMachine = .initial
        // TODO: make an API request here
    }
    
}
