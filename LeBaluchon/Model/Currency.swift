//
//  Currency.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 08/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Currencies: Decodable {
    let symbols: [String: String]
}

struct Exchange: Decodable {
    let rates: [String: String]
}

