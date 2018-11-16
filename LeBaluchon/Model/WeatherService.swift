//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 06/11/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class WeatherService: APIService {
    var urlSession: URLSession
    var task: URLSessionDataTask?
    
    var locations: [Location] = [Location(city: "Chantilly", country: "fr"),
                                 Location(city: "New-York", country: "us")]
    var weathers: [Channel] = []
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
    
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
    
    func createWeatherSelect() -> String {
        var locationsParameter: String = ""
        
        for location in locations {
            locationsParameter = locationsParameter + "'\(location.city), \(location.country)',"
        }
        locationsParameter.removeLast()
        
        let select = URLWeather.select.replacingOccurrences(of: "%locations", with: locationsParameter)
        
        return select
    }
}
