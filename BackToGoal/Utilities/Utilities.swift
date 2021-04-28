//
//  Utilities.swift
//  FitnessTracker
//
//  Created by Apurva Bhoite on 4/26/21.
//

import Foundation

extension String{
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
