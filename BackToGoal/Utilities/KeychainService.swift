//
//  KeychainService.swift
//  FitnessTracker
//
//  Created by Apurva Bhoite on 4/27/21.
//

import Foundation
import KeychainSwift

class KeychainService{
    
    var _localVar = KeychainSwift()
    
    var keyChain : KeychainSwift{
        get {
            return _localVar
        }
        set {
            _localVar = newValue
        }
    }
}
