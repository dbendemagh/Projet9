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
    
    var currencies: [String: String] = [:]
    var currentToCurrency: String = "USD"
    var currentExchangeRate: Double = 0
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
    
    func createFixerRequest(endPoint: String, currency: String = "") -> URLRequest {
        var urlString: String = URLFixer.baseURL + endPoint + "&access_key=" + URLFixer.apiKey
        
        if currency != "" {
            urlString = urlString + "&symbols=" + currency
        }
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    
}

