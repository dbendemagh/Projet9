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
    
    var apiKey = ""
    var languages: [Language] = []
    
    var fromLanguage: Language = Language(code: "en",name: "English")
    var toLanguage: Language = Language(code: "fr",name: "French")
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
        
        apiKey = getApiKey(key: "GoogleTranslateKey")
    }
    
    // Create request to retrieve languages list
    func createLanguagesRequest() -> URLRequest {
        let urlString: String = URLTranslation.baseURL + URLTranslation.languages + "?key=\(apiKey)&target=en"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    // Create translation request with selected languages
    func createTranslationRequest(text: String) -> URLRequest {
        let urlString: String = URLTranslation.baseURL
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = "key=\(apiKey)&source=\(fromLanguage.code)&target=\(toLanguage.code)&format=text&q=\(text)"
        
        request.httpBody = body.data(using: .utf8)
        
        //print(request.url)
        //print(request.httpBody)
        
        return request
    }
    
    // Fetch language code according to language name
    func languageCode(languageName: String) -> String {
        for language in languages {
            if language.name == languageName {
                return language.code
            }
        }
        
        return ""
    }
    
    func swapLanguages() {
        let language = fromLanguage
        
        fromLanguage = toLanguage
        toLanguage = language
    }
}
