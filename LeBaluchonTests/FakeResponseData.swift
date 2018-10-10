//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Daniel BENDEMAGH on 07/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class FakeResponseData {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://fakenews.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://fakenews.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class ResponseError: Error {}
    static let error = ResponseError()
    
    static let quoteIncorrectData = "erreur".data(using: .utf8)!
    
    static let imageData = "image".data(using: .utf8)
    
}

class FakeCurrencySymbolsResponseData {
    static var CorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "CurrencySymbols", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
}
