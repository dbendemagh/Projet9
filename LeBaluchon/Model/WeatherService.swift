//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 06/11/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class WeatherService: APIService {
    
    // MARK: - Properties
    
    var urlSession: URLSession
    var task: URLSessionDataTask?
    
    var apiKey = ""
    var weathers: [WeatherModel] = []
    
    //var weather: WeatherData
    
    // MARK: - Methods
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
        apiKey = getApiKey(key: "OpenweathermapKey")
    }
    
    // Create URL request
    func createWeatherRequest(_ city: String, _ country: String) -> URLRequest? {
        
        let urlString: String = "\(URLWeather.baseURL)?appid=\(apiKey)&q=\(city),\(country)&units=metric&lang=fr"
        guard let encodeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil}
        
        guard let url = URL(string: encodeUrlString) else {
            print("Erreur URL !")
            return nil }

        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    func createWeatherRequest(_ latitude: Double, _ longitude: Double) -> URLRequest? {
        
        let urlString: String = "\(URLWeather.baseURL)?appid=\(apiKey)&lat=\(latitude)&lon=\(longitude)&units=metric&lang=fr"
        guard let url = URL(string: urlString) else { return nil }

        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
