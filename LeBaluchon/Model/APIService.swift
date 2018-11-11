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
    mutating func get<T: Decodable>(request: URLRequest, callBack: @escaping (Bool, T?) -> ()) {
        
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
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                
//                do {
//                    let resp = try JSONDecoder().decode(T.self, from: data)
//                }
//                catch {
//                    print(error)
//                }
                
                guard let responseJSON = try? JSONDecoder().decode(T.self, from: data) else {
                    callBack(false, nil)
                    return
                }
                
                print(responseJSON)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                
                callBack(true, responseJSON)
                

            }
        }
        task?.resume()
    }
}

