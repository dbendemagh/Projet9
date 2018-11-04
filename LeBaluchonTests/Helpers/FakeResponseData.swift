//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Daniel BENDEMAGH on 07/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class FakeResponseData {
    
    let responseOK = HTTPURLResponse(url: URL(string: "https://ok.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    let responseKO = HTTPURLResponse(url: URL(string: "https://ko.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class ResponseError: Error {}
    let error = ResponseError()
    
    let correctData: Data
    
    let incorrectData = "error".data(using: .utf8)!
    
    init(jsonFile: String) {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: jsonFile, withExtension: "json")
        correctData = try! Data(contentsOf: url!)
    }
}
