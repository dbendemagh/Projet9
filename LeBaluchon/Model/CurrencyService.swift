//
//  ExchangeRate.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 09/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class CurrencyService {
    private var task: URLSessionDataTask?
    private var urlSession: URLSession
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
    
    func getCurrencySymbols(callBack: @escaping (Bool, CurrencyName?) -> ()) {
        let request = createFixerRequest(endPoint: URLFixer.currencies)

        task = urlSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(false, nil)
                    return
                }
                
                print(data)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callBack(false, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(CurrencyName.self, from: data) else {
                    callBack(false, nil)
                    return
                }
                
                //self.currencies = responseJSON.symbols
                print("Get ok")
                
                callBack(true, responseJSON)
            }
        }
        task?.resume()
    }
    
    func getExchangeRate(currency: String, callBack: @escaping (Bool, Double?) -> ()) {
        currentExchangeRate = 0
        
        let request = createFixerRequest(endPoint: URLFixer.rates, currency: currency)
        
        task = urlSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(false, nil)
                    return
                }
                
                print(data)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callBack(false, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(ExchangeRate.self, from: data), let exchangeRate = responseJSON.rates[currency] else {
                    callBack(false, nil)
                    return
                }
                
                print("Get ok \(exchangeRate)")
                
                callBack(true, exchangeRate)
            }
        }
        task?.resume()
    }
}
