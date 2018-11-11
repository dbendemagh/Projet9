//
//  TranslationTestCase.swift
//  LeBaluchonTests
//
//  Created by Daniel BENDEMAGH on 02/11/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class TranslationTestCase: XCTestCase {
    var text: String = ""
    
    override func setUp() {
        text = "Hello"
    }
    
    func testGetTranslationShouldPostFailedCallback() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Translation)
        var translationService = TranslationService(urlSession: URLSessionFake(data: nil, response: nil, error: fakeResponseData.error))
        let request = translationService.createTranslationRequest(source: "fr", target: "en", text: text)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.get(request: request) { (success, translation: Translation?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfNoData() {
        // Given
        var translationService = TranslationService(urlSession: URLSessionFake(data: nil, response: nil, error: nil))
        let request = translationService.createTranslationRequest(source: "fr", target: "en", text: text)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.get(request: request) { (success, translation: Translation?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Translation)
        var translationService = TranslationService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseKO, error: nil))
        let request = translationService.createTranslationRequest(source: "fr", target: "en", text: text)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.get(request: request) { (success, translation: Translation?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Translation)
        let urlSessionFake = URLSessionFake(data: fakeResponseData.incorrectData, response: fakeResponseData.responseOK, error: nil)
        var translationService = TranslationService(urlSession: urlSessionFake)
        let request = translationService.createTranslationRequest(source: "fr", target: "en", text: text)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.get(request: request) { (success, translation: Translation?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Translation)
        var translationService = TranslationService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil))
        let request = translationService.createTranslationRequest(source: "fr", target: "en", text: text)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.get(request: request) { (success, translation: Translation?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(translation)
            XCTAssertEqual(translation?.data.translations[0].translatedText, "Bonjour")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenLanguageIsFrench_WhenCallLanguageCode_ThenShouldReturnfr() {
        let translationService = TranslationService()
        
        let request = translationService.createLanguagesRequest()
        
        translationService.languages = [Language(language: "fr", name: "French"),Language(language: "en", name: "English")]
        
        XCTAssertEqual(translationService.languageCode(languageName: "French"), "fr")
        
    }
    
    func testGivenLanguageIsTruc_WhenCallLanguageCode_ThenShouldReturnNothing() {
        let translationService = TranslationService()
        
        translationService.languages = [Language(language: "fr", name: "French"),Language(language: "en", name: "English")]
        
        XCTAssertEqual(translationService.languageCode(languageName: "Truc"), "")
        
    }
}
