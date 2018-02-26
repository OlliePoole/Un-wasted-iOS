//
//  FindFoodDetailViewModel.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation

protocol FindFoodDetailViewModelInputs: class {
    func bite(foodItem item: FoodItem)
    func verifyBite(foodItem item: FoodItem, code: String)
}

protocol FindFoodDetailViewModelOutputs: class {
    var biteLoadingStateMachine: LoadingStateMachine<Bool> { get set }
    
    var verifyLoadingStateMachine: LoadingStateMachine<Bool> { get set }
}

class FindFoodDetailViewModel {
    
    private var biteLoadingStateMachine: LoadingStateMachine<Bool> = .initial {
        didSet {
            self.outputs?.biteLoadingStateMachine = biteLoadingStateMachine
        }
    }
    
    private var verifyLoadingStateMachine: LoadingStateMachine<Bool> = .initial {
        didSet {
            self.outputs?.verifyLoadingStateMachine = verifyLoadingStateMachine
        }
    }
    
    private let findFoodService: FindFoodServiceType
    
    private (set) weak var outputs: FindFoodDetailViewModelOutputs?
    var inputs: FindFoodDetailViewModelInputs {
        return self
    }
    
    init(outputs: FindFoodDetailViewModelOutputs, findFoodServiceType: FindFoodServiceType = FindFoodService()) {
        self.outputs = outputs
        self.findFoodService = findFoodServiceType
    }
}

extension FindFoodDetailViewModel: FindFoodDetailViewModelInputs {
 
    func bite(foodItem item: FoodItem) {
        guard biteLoadingStateMachine != .loading else {
            return
        }
        
        biteLoadingStateMachine = .loading
        findFoodService.biteFood(foodItem: item, success: {
            self.biteLoadingStateMachine = .loaded(items: [])
            
            LocalBiteStorage.shared.registerBite(on: item)
            
        }) { error in
            self.biteLoadingStateMachine = .error(error: error)
        }
    }
    
    func verifyBite(foodItem item: FoodItem, code: String) {
        
    }
    
}


