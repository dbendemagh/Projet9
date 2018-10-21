//
//  ExchangeRate.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 09/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class CurrencyService {
    var currencies: [String: String] = [:]
    
    func convert() {
        
    }
    
    func createFixerRequest(endPoint: String) -> URLRequest {
        let url = URL(string: URLFixer.baseURL + endPoint + "&access_key=" + URLFixer.apiKey)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
}
