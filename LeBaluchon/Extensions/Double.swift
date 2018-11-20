//
//  Double.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 29/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

extension Double {
    func fraction(_ value: Int) -> String {
        return String(format: "%.\(value)f", self)
    }
    
    func fraction0() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.usesGroupingSeparator = false
        formatter.maximumFractionDigits = 2
        
        let value: Double = self
        let nsnumberValue: NSNumber = NSNumber(value: value)
        
        if let roundedValue = formatter.string(from: nsnumberValue) {
            return roundedValue
        }
        
        return ""
    }
}
