//
//  ProfileViewModel.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import Foundation

protocol ProfileViewModelInputs: class {
    func loadProfile()
}

protocol ProfileViewModelOutputs: class {
    var profileLoadingStateMachine: LoadingStateMachine<User> { get set }
}

class ProfileViewModel {
    
    private var profileLoadingStateMachine: LoadingStateMachine<User> = .initial {
        didSet {
            self.outputs?.profileLoadingStateMachine = profileLoadingStateMachine
        }
    }
    
    private (set) weak var outputs: ProfileViewModelOutputs?
    var inputs: ProfileViewModelInputs {
        return self
    }
    
    init(outputs: ProfileViewModelOutputs) {
        self.outputs = outputs
    }
    
}


extension ProfileViewModel: ProfileViewModelInputs {
    
    func loadProfile() {
        guard profileLoadingStateMachine != .loading else {
            return
        }
        
        profileLoadingStateMachine = .loading
        // TODO: make network request here
    }
}
