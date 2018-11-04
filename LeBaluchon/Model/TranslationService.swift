//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 02/11/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class TranslationService : APIService {
    var urlSession: URLSession
    
    var task: URLSessionDataTask?
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
    
    func createTranslationRequest(source: String, target: String, text: String) -> URLRequest {
        let urlString: String = URLTranslation.baseURL + "?" + "key=\(URLTranslation.apiKey)&source=\(source)&target=\(target)&format=text&q=\(text)"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //let body = "key=\(URLTranslation.apiKey)&source=\(source)&target=\(target)&format=text&text=\(text)"
        
        //request.httpBody = body.data(using: .utf8)
        
        print(request.url)
        print(request.httpBody)
        
        return request
    }
}
