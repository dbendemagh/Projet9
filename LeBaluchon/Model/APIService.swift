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
    
    mutating func get<T: Decodable>(request: URLRequest, callBack: @escaping (Bool, T?) -> Void)
}

extension APIService {
    
    // Get API Key from Apikeys.plist
    func getApiKey(key: String) -> String {
        var apiKey = ""
        
        guard let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else {
            fatalError("ApiKeys.plist not found")
        }
        
        let url = URL(fileURLWithPath: path)
        if let obj = NSDictionary(contentsOf: url), let value = obj.value(forKey: key) {
            apiKey = value as? String ?? ""
        }
        
        return apiKey
    }
    
    // Generic function
    mutating func get<T: Decodable>(request: URLRequest, callBack: @escaping (Bool, T?) -> Void) {
        
        task = urlSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callBack(false, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(T.self, from: data) else {
                    callBack(false, nil)
                    return
                }
                
                callBack(true, responseJSON)
            }
        }
        task?.resume()
    }
}
