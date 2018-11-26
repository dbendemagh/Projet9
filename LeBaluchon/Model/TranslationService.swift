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
    
    var languages: [Language] = []
    
    var fromLangage: String = "ENG"
    var toLangage: String = "FRA"
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
    
    func createLanguagesRequest() -> URLRequest {
        let urlString: String = URLTranslation.baseURL + URLTranslation.languages + "?key=\(URLTranslation.apiKey)&target=en"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    func createTranslationRequest(source: String, target: String, text: String) -> URLRequest {
        let urlString: String = URLTranslation.baseURL
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = "key=\(URLTranslation.apiKey)&source=\(source)&target=\(target)&format=text&q=\(text)"
        
        request.httpBody = body.data(using: .utf8)
        
        print(request.url)
        print(request.httpBody)
        
        return request
    }
    
    func langageName(code: String) -> String? {
        for language in languages {
            if language.name == code {
                return language.name
            }
        }
        
        return nil
    }
    
    func languageCode(languageName: String) -> String? {
        for itemLanguage in languages {
            if itemLanguage.name == languageName {
                return itemLanguage.language
            }
        }
        
        return nil
    }
    
    func reverseLangages() {
        let langage = fromLangage
        
        fromLangage = toLangage
        toLangage = langage
    }
}
