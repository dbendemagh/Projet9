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
    
    let locations: [Location] = [Location(city: "New-York", country: "us"),
                                 Location(city: "La Chapelle-en-serval", country: "fr")]
    var weathers: [Channel] = []
    
    // MARK: - Methods
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
    
    // Create URL request
    func createWeatherRequest() -> URLRequest? {
        
        let weatherSelect = createWeatherSelect()
        
        guard let encodedWeatherSelect = weatherSelect.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        
        let urlString: String = "\(URLWeather.baseURL)?\(encodedWeatherSelect)&format=json"
        let url = URL(string: urlString)!

        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    // Create Yahoo weather select
    private func createWeatherSelect() -> String {
        var locationsParameter: String = ""
        
        for location in locations {
            locationsParameter += "'\(location.city), \(location.country)',"
        }
        locationsParameter.removeLast()
        
        let select = URLWeather.select.replacingOccurrences(of: "%locations", with: locationsParameter)
        
        return select
    }
}
