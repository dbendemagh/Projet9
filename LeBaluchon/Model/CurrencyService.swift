//
//  ExchangeRate.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 09/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class CurrencyService: APIService {
    
    // MARK: - Properties
    
    var urlSession: URLSession
    var task: URLSessionDataTask?
    
    var apiKey = ""
    
    var currencies: [Currency] = []
    var exchangeRates: [String: Double] = [:]
    
    var fromCurrency: String = "EUR"
    var toCurrency: String = "USD"
    
    // Exchange rate (Euro based)
    var fromExchangeRate: Double = 0
    var toExchangeRate: Double = 0
    var exchangeRate: Double {
        if fromCurrency == "EUR" {
            return toExchangeRate
        } else {
            guard fromExchangeRate != 0 else { return 0 }
            return toExchangeRate / fromExchangeRate
        }
    }
    
    // MARK: Methods
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
        
        apiKey = getApiKey(key: "FixerKey")
    }
    
    // Create URL Request
    func createFixerRequest(endPoint: String, currencyConversion: Bool = false) -> URLRequest {
        var urlString: String = URLFixer.baseURL + endPoint + "&access_key=" + apiKey
        
        if currencyConversion {
            urlString += "&symbols=\(fromCurrency),\(toCurrency)"
        }
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    // Fetch currency name according to currency code
    func currencyName(code: String) -> String? {
        for currency in currencies where currency.code == code {
            return currency.name
        }
        
        return nil
    }
    
    func swapCurrencies() {
        let currency = fromCurrency
        let exchangeRate = fromExchangeRate
        
        fromCurrency = toCurrency
        toCurrency = currency
        
        fromExchangeRate = toExchangeRate
        toExchangeRate = exchangeRate
    }
}
