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
        let urlSessionFake = URLSessionFake(data: nil, response: nil, error: fakeResponseData.error)
        //let apiService = APIService(apiSession: urlSessionFake)
        let currencyService = CurrencyService(urlSession: urlSessionFake)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        currencyService.getCurrencySymbols { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currencyName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrencySymbolsShouldPostFailedCallbackIfNoData() {
        // Given
        let urlSessionFake = URLSessionFake(data: nil, response: nil, error: nil)
        let currencyService = CurrencyService(urlSession: urlSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getCurrencySymbols { (success, currencyName: CurrencyName?) in
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
        let urlSessionFake = URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseKO, error: nil)
        let currencyService = CurrencyService(urlSession: urlSessionFake)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getCurrencySymbols { (success, currencyName: CurrencyName?) in
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
        let currencyService = CurrencyService(urlSession: urlSessionFake)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getCurrencySymbols { (success, currencyName: CurrencyName?) in
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
        let urlSessionFake = URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil)
        let currencyService = CurrencyService(urlSession: urlSessionFake)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        currencyService.getCurrencySymbols { (success, currencyName: CurrencyName?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(currencyName)
            XCTAssertEqual((currencyName?.symbols["EUR"])!, "Euro")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostFailedCallback() {
        
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.ExchangeRate)
        let urlSessionFake = URLSessionFake(data: nil, response: nil, error: fakeResponseData.error)
        //let apiService = APIService(apiSession: urlSessionFake)
        let currencyService = CurrencyService(urlSession: urlSessionFake)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        currencyService.getExchangeRate(currency: "USD") { (success, exchangeRate: Double?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostFailedCallbackIfNoData() {
        // Given
        let urlSessionFake = URLSessionFake(data: nil, response: nil, error: nil)
        let currencyService = CurrencyService(urlSession: urlSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getExchangeRate(currency: "USD") { (success, exchangeRate: Double?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.ExchangeRate)
        let urlSessionFake = URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseKO, error: nil)
        let currencyService = CurrencyService(urlSession: urlSessionFake)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getExchangeRate(currency: "USD") { (success, exchangeRate: Double?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.ExchangeRate)
        let urlSessionFake = URLSessionFake(data: fakeResponseData.incorrectData, response: fakeResponseData.responseOK, error: nil)
        let currencyService = CurrencyService(urlSession: urlSessionFake)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getExchangeRate(currency: "USD") { (success, exchangeRate: Double?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponseData = FakeResponseData(jsonFile: JSON.ExchangeRate)
        let urlSessionFake = URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil)
        let currencyService = CurrencyService(urlSession: urlSessionFake)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        currencyService.getExchangeRate(currency: "USD") { (success, exchangeRate: Double?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(exchangeRate)
            XCTAssertEqual(exchangeRate, 1.15783)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
}
