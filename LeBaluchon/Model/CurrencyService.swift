//
//  ExchangeRate.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 09/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class CurrencyService: APIService {
    var urlSession: URLSession
    var task: URLSessionDataTask?
    
    //internal var urlSession: URLSession
    //internal var task: URLSessionDataTask?
    
    //var apiSession: URLSession
    
    //let apiService = APIService()
    
    var currencies: [Currency] = []
    
    var sortedCurrencies: [String] = []
    
    var exchangeRates: [String: Double] = [:]
    var exchangeRateTimestamp = 0
    
    var fromCurrency: String = "EUR"
    var toCurrency: String = "USD"
    
    // Exchange rate (Euro based)
    var fromExchangeRate: Double = 0
    var toExchangeRate: Double = 0
    var exchangeRate: Double {
        get {
            if fromCurrency == "EUR" {
                return toExchangeRate
            } else {
                return toExchangeRate / fromExchangeRate
            }
        }
    }
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
    
    func createFixerRequest(endPoint: String, currencyConversion: Bool = false) -> URLRequest {
        var urlString: String = URLFixer.baseURL + endPoint + "&access_key=" + URLFixer.apiKey
        
        if currencyConversion {
            urlString = urlString + "&symbols=\(fromCurrency),\(toCurrency)"
        }
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    func currencyName(code: String) -> String {
        for currency in currencies {
            if currency.code == code {
                return currency.name
            }
        }
        
        return ""
    }
    
    func getExchangeRate() -> Double {
        if fromCurrency == "EUR" {
            return toExchangeRate
        } else {
            return toExchangeRate / fromExchangeRate
        }
    }
    // Exchange rate based on Euro
    func calculateExchangeRate(fromCurrency: String, toCurrency: String) -> Double? {
        guard let fromExchangeRate: Double = exchangeRates[fromCurrency],
            let toExchangeRate: Double = exchangeRates[toCurrency] else { return nil }
        return toExchangeRate / fromExchangeRate
    }
}

