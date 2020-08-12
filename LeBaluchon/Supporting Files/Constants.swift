//
//  Constants.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 08/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct URLFixer {
    static let baseURL = "http://data.fixer.io/api/"
    static let currencies = "symbols"
    static let rates = "latest"
}

struct URLTranslation {
    static let baseURL = "https://translation.googleapis.com/language/translate/v2/"
    static let languages = "languages"
}

struct URLWeather {
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
}

struct JSON {
    static let CurrencySymbols = "CurrencySymbols"
    static let ExchangeRate = "ExchangeRate"
    static let Languages = "Languages"
    static let Translation = "Translation"
    static let Weather = "Weather"
}
