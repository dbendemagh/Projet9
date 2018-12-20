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
    
    // Tests list languages
    func testGetLanguagesShouldPostFailedCallback() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Languages)
        var translationService = TranslationService(urlSession: URLSessionFake(data: nil, response: nil, error: fakeResponseData.error))
        let request = translationService.createLanguagesRequest()
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.get(request: request) { (success, languagesList: LanguagesList?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languagesList)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetLanguagesShouldPostFailedCallbackIfNoData() {
        // Given
        var translationService = TranslationService(urlSession: URLSessionFake(data: nil, response: nil, error: nil))
        let request = translationService.createLanguagesRequest()
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.get(request: request) { (success, languagesList: LanguagesList?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languagesList)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetLanguagesShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Languages)
        var translationService = TranslationService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseKO, error: nil))
        let request = translationService.createLanguagesRequest()
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.get(request: request) { (success, languagesList: LanguagesList?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languagesList)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetLanguagesShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Languages)
        let urlSessionFake = URLSessionFake(data: fakeResponseData.incorrectData, response: fakeResponseData.responseOK, error: nil)
        var translationService = TranslationService(urlSession: urlSessionFake)
        let request = translationService.createTranslationRequest(text: text)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.get(request: request) { (success, languagesList: LanguagesList?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languagesList)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetLanguagesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Languages)
        var translationService = TranslationService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil))
        let request = translationService.createLanguagesRequest()
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.get(request: request) { (success, languagesList: LanguagesList?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(languagesList)
            XCTAssertEqual(languagesList?.data.languages[0].code, "af")
            XCTAssertEqual(languagesList?.data.languages[0].name, "Afrikaans")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Tests translation
    func testGetTranslationShouldPostFailedCallback() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Translation)
        var translationService = TranslationService(urlSession: URLSessionFake(data: nil, response: nil, error: fakeResponseData.error))
        translationService.fromLanguage = Language(code: "fr", name: "French")
        translationService.toLanguage = Language(code: "en", name: "English")
        let request = translationService.createTranslationRequest(text: text)
        
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
        translationService.fromLanguage = Language(code: "fr", name: "French")
        translationService.toLanguage = Language(code: "en", name: "English")
        let request = translationService.createTranslationRequest(text: text)
        
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
        translationService.fromLanguage = Language(code: "fr", name: "French")
        translationService.toLanguage = Language(code: "en", name: "English")
        let request = translationService.createTranslationRequest(text: text)
        
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
        translationService.fromLanguage = Language(code: "fr", name: "French")
        translationService.toLanguage = Language(code: "en", name: "English")
        let request = translationService.createTranslationRequest(text: text)
        
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
        translationService.fromLanguage = Language(code: "fr", name: "French")
        translationService.toLanguage = Language(code: "en", name: "English")
        let request = translationService.createTranslationRequest(text: text)
        
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
        
        //let request = translationService.createLanguagesRequest()
        
        translationService.languages = [Language(code: "fr", name: "French"), Language(code: "en", name: "English")]
        
        XCTAssertEqual(translationService.languageCode(languageName: "French"), "fr")
    }
    
    func testGivenLanguageIsUnknown_WhenCallLanguageCode_ThenShouldReturnNothing() {
        let translationService = TranslationService()
        
        translationService.languages = [Language(code: "fr", name: "French"), Language(code: "en", name: "English")]
        
        XCTAssertEqual(translationService.languageCode(languageName: "Unknown"), "")
    }
    
    func testLanguageCode_NameIsFrench_ShouldReturnfr() {
        let translationService = TranslationService()
        translationService.languages = [Language(code: "fr", name: "French")]
        
        XCTAssertEqual(translationService.languageCode(languageName: "French"), "fr")
    }
    
    func testLanguageCode_NameIsIncorrect_ShouldReturnEmpty() {
        let translationService = TranslationService()
        translationService.languages = [Language(code: "fr", name: "French")]
        
        XCTAssertEqual(translationService.languageCode(languageName: "ABC"), "")
    }
    
    func testReverseLanguages_TranslationIsFromFRToEN_ShouldSetTranslationFromENToFR() {
        let translationService = TranslationService()
        
        translationService.fromLanguage = Language(code: "fr", name: "French")
        translationService.toLanguage = Language(code: "en", name: "English")
        
        translationService.swapLanguages()
        
        XCTAssertEqual(translationService.fromLanguage.code, "en")
        XCTAssertEqual(translationService.fromLanguage.name, "English")
        XCTAssertEqual(translationService.toLanguage.code, "fr")
        XCTAssertEqual(translationService.toLanguage.name, "French")
    }
}
