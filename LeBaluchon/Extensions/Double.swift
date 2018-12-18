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
}
