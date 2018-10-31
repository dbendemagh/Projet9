//
//  APIService.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 07/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

protocol APIService {
    var urlSession: URLSession { get set }
    var task: URLSessionDataTask? { get set }
    
    mutating func get<T: Decodable>(request: URLRequest, callBack: @escaping (Bool, T?) -> ())
}

extension APIService {
    
    //private var task: URLSessionDataTask?
    //private var apiSession: URLSession    // = URLSession(configuration: .default)
    
    //private var imageSession: URLSession    //= URLSession(configuration: .default)
    
    mutating func get<T: Decodable>(request: URLRequest, callBack: @escaping (Bool, T?) -> ()) {
        
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
                
                guard let responseJSON = try? JSONDecoder().decode(T.self, from: data) else {
                    callBack(false, nil)
                    return
                }
                
                print("Get ok")
                
                callBack(true, responseJSON)
                

            }
        }
        task?.resume()
    }
    
//    private func createQuoteRequest() -> URLRequest {
//        var request = URLRequest(url: QuoteService.quoteURL)
//        request.httpMethod = "POST"
//
//        let body = "method=getQuote&format=json&lang=en"
//        request.httpBody = body.data(using: .utf8)
//
//        return request
//    }
    
    
}
