//
//  APIService.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 07/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class APIService {
    //static var shared = QuoteService()
    //private init() {}
    
    private static let quoteURL = URL(string: "https://api.forismatic.com/api/1.0/")!
    private static let pictureURL = URL(string: "https://source.unsplash.com/random/1000x1000")!
    
    private var task: URLSessionDataTask?
    
    private var apiSession: URLSession    // = URLSession(configuration: .default)
    //private var imageSession: URLSession    //= URLSession(configuration: .default)
    
    init(apiSession: URLSession = URLSession(configuration: .default)) {
        self.apiSession = apiSession
        //self.imageSession = imageSession
    }
    
    func get<T: Decodable>(request: URLRequest, callBack: @escaping (Bool, T?) -> ()) {
        
        task = apiSession.dataTask(with: request) { (data, response, error) in
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
                
                do {
                    let responseJSON = try JSONDecoder().decode(T.self, from: data)
                    callBack(true, responseJSON)
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
                
//                guard let responseJSON = try? JSONDecoder().decode(T.self, from: data),
//                    let text = responseJSON["quoteText"],
//                    let author = responseJSON["quoteAuthor"] else {
//                        callBack(false, nil)
//                        return
//                }
                
                //getImage(completionHandler: { (data) in
                //    <#code#>
                //})
//                self.getImage { (data) in
//                    if let data = data {
//                        let quote = Quote(text: text, author: author, imageData: data)
//                        callBack(true, quote)
//                    } else {
//                        callBack(false, nil)
//                    }
//                }
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
    
    func createFixerRequest(endPoint: String) -> URLRequest {
        let url = URL(string: URLFixer.baseURL + endPoint + "&access_key=" + URLFixer.apiKey)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
