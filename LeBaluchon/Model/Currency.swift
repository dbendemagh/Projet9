//
//  Currency.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 08/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct CurrencyName: Decodable {
    let symbols: [String: String]
}

struct ExchangeRate: Decodable {
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}

