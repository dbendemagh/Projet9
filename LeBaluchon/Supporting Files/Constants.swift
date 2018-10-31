//
//  Constants.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 08/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct URLFixer {
    // en majuscule ?
    static let baseURL = "http://data.fixer.io/api/"
    static let currencies = "symbols"
    static let rates = "latest"
    static let apiKey = "cf699e9d9bdb0aee906bbde37b77ea52"
}

struct URLTranslation {
    static let baseURL = "https://translation.googleapis.com/language/translate/v2/"
    static let apiKey = "AIzaSyA04wv256ASngsHO8hfd-FA31bsOyEOah8"
    
}

struct JSON {
    static let CurrencySymbols = "CurrencySymbols"
    static let ExchangeRate = "ExchangeRate"
}

