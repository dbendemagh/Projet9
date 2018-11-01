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
    func testGetCurrencySymbolsShouldPostFailedCallback() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.CurrencySymbols)
        var currencyService = CurrencyService(urlSession: URLSessionFake(data: nil, response: nil, error: fakeResponseData.error))
        let request = currencyService.createFixerRequest(endPoint: URLFixer.currencies)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        currencyService.get(request: request) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currencyName)
            expectation.fulfill()
        }
        
//        currencyService.getCurrencySymbols { (success, currencyName: CurrencyName?) in
//            // Then
//            XCTAssertFalse(success)
//            XCTAssertNil(currencyName)
//            expectation.fulfill()
//        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrencySymbolsShouldPostFailedCallbackIfNoData() {
        // Given
        var currencyService = CurrencyService(urlSession: URLSessionFake(data: nil, response: nil, error: nil))
        let request = currencyService.createFixerRequest(endPoint: URLFixer.currencies)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.get(request: request) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currencyName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrencySymbolsShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.ExchangeRate)
        var currencyService = CurrencyService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseKO, error: nil))
        let request = currencyService.createFixerRequest(endPoint: URLFixer.currencies)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.get(request: request) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currencyName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrencySymbolsShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.CurrencySymbols)
        let urlSessionFake = URLSessionFake(data: fakeResponseData.incorrectData, response: fakeResponseData.responseOK, error: nil)
        var currencyService = CurrencyService(urlSession: urlSessionFake)
        let request = currencyService.createFixerRequest(endPoint: URLFixer.currencies)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.get(request: request) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currencyName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetCurrencySymbolsShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.CurrencySymbols)
        var currencyService = CurrencyService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil))
        let request = currencyService.createFixerRequest(endPoint: URLFixer.currencies)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        currencyService.get(request: request) { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(currencyName)
            XCTAssertEqual((currencyName?.symbols["EUR"])!, "Euro")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponseData = FakeResponseData(jsonFile: JSON.ExchangeRate)
        var currencyService = CurrencyService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil))
        let request = currencyService.createFixerRequest(endPoint: URLFixer.rates, currency: "USD")
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        currencyService.get(request: request) { (success, exchangeRate: ExchangeRate?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(exchangeRate)
            XCTAssertEqual(exchangeRate?.rates["USD"], 1.15783)
            expectation.fulfill()
        }
        
//        currencyService.getExchangeRate(currency: "USD") { (success, exchangeRate: Double?) in
//            // Then
//            XCTAssertTrue(success)
//            XCTAssertNotNil(exchangeRate)
//            XCTAssertEqual(exchangeRate, 1.15783)
//            expectation.fulfill()
//        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
}
