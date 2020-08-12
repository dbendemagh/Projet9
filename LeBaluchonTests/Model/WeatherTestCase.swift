//
//  WeatherTestCase.swift
//  LeBaluchonTests
//
//  Created by Daniel BENDEMAGH on 06/11/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class WeatherTestCase: XCTestCase {
    let city = "Chantilly"
    let longitude = 2.47
    let latitude = 49.19
    
    func testGetWeatherShouldPostFailedCallback() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Weather)
        var weatherService = WeatherService(urlSession: URLSessionFake(data: nil, response: nil, error: fakeResponseData.error))
        guard let request = weatherService.createWeatherRequest(city, "fr") else { return }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        weatherService.get(request: request) { (success, weather: Weather?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        // Given
        var weatherService = WeatherService(urlSession: URLSessionFake(data: nil, response: nil, error: nil))
        guard let request = weatherService.createWeatherRequest(city, "fr") else { return }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.get(request: request) { (success, weather: Weather?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Translation)
        var weatherService = WeatherService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseKO, error: nil))
        guard let request = weatherService.createWeatherRequest(city, "fr") else { return }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.get(request: request) { (success, weather: Weather?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Translation)
        let urlSessionFake = URLSessionFake(data: fakeResponseData.incorrectData, response: fakeResponseData.responseOK, error: nil)
        var weatherService = WeatherService(urlSession: urlSessionFake)
        guard let request = weatherService.createWeatherRequest(city, "fr") else { return }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.get(request: request) { (success, weather: Weather?) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Weather)
        var weatherService = WeatherService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil))
        guard let request = weatherService.createWeatherRequest(city, "fr") else { return }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        weatherService.get(request: request) { (success, weather: WeatherData?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            XCTAssertEqual(weather?.name, self.city)
            XCTAssertEqual(weather?.main.temp, 29.36)
            XCTAssertEqual(weather!.weather[0].description, "partiellement nuageux")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherLatLongShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let fakeResponseData = FakeResponseData(jsonFile: JSON.Weather)
        var weatherService = WeatherService(urlSession: URLSessionFake(data: fakeResponseData.correctData, response: fakeResponseData.responseOK, error: nil))
        guard let request = weatherService.createWeatherRequest(latitude, longitude) else { return }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        weatherService.get(request: request) { (success, weather: WeatherData?) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            XCTAssertEqual(weather?.name, self.city)
            XCTAssertEqual(weather?.main.temp, 29.36)
            XCTAssertEqual(weather!.weather[0].description, "partiellement nuageux")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
