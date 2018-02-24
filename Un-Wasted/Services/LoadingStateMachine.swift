//
//  LoadingStateMachine.swift
//  DutchCourage
//
//  Created by Oliver Poole on 12/07/2017.
//
//

import Foundation

enum LoadingStateMachine<T: Equatable>: Equatable {
    
    /// The machine is awaiting instructions
    case initial
    
    /// The content is loading
    case loading
    
    /// the content has loaded
    case loaded(items: [T])
    
    /// There was an error loading the content
    case error(error: NetworkError)
}


func ==<T>(lhs: LoadingStateMachine<T>, rhs: LoadingStateMachine<T>) -> Bool {
    
    switch (lhs, rhs) {
    case (.initial, .initial), (.loading, .loading):
        return true
        
    case (let .error(error1), let .error(error2)):
        return error1 == error2
        
    case (let .loaded(items1), let .loaded(items2)):
        return items1 == items2
        
    default:
        return false
    }
    
}
