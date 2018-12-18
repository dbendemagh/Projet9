//
//  Currency.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 08/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

// MARK: - Fixer.io Json
struct CurrencyName: Decodable {
    let symbols: [String: String]
}

struct ExchangeRate: Decodable {
    let timestamp: Int
    let rates: [String: Double]
}

// MARK: - Struct for Currencies Array
struct Currency {
    let code: String
    let name: String
}
