//
//  CurrencyServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Daniel BENDEMAGH on 07/10/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class CurrencyServiceTestCase: XCTestCase {
    let exchangeRate = CurrencyService()
    var fixerRequest: URLRequest?
    
    override func setUp() {
        fixerRequest = exchangeRate.createFixerRequest(endPoint: URLFixer.currencies)
    }
    
    func testGetCurrenciesShouldPostFailedCallback() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSONCurrencySymbols)
        let urlSessionFake = URLSessionFake(data: nil, response: nil, error: fakeResponseData.error)
        let apiService = APIService(apiSession: urlSessionFake)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        apiService.get(request: fixerRequest!) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currencyName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesShouldPostFailedCallbackIfNoData() {
        // Given
        let apiService = APIService(apiSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.get(request: fixerRequest!) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currencyName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSONCurrencySymbols)
        let apiService = APIService(apiSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.get(request: fixerRequest!) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currencyName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCurrenciesGetShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSONCurrencySymbols)
        let apiService = APIService(apiSession: URLSessionFake(data: fakeResponseData.incorrectData, response: fakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.get(request: fixerRequest!) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currencyName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetCurrenciesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSONCurrencySymbols)
        let apiService = APIService(apiSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.get(request: fixerRequest!) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(currencyName)
            
            XCTAssertEqual((currencyName?.symbols["EUR"])!, "Euro")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    // nom à revoir
    func testGetExchangeRateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponseData = FakeResponseData(jsonFile: JSONExchangeRate)
        let apiService = APIService(apiSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.get(request: fixerRequest!) { (success, exchangeRate: ExchangeRate?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(exchangeRate)
            
            XCTAssertEqual((exchangeRate?.rates ["AED"])!, 4.252936)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
}
