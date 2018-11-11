//
//  WeatherVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var weatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getWeather()
    }

    func getWeather() {
        guard let request = weatherService.createWeatherRequest() else { return }
        
        toggleActivityIndicator(shown: true)
        weatherService.get(request: request) { (success, weather: Weather?) in
            self.toggleActivityIndicator(shown: false)
            if success, let weather = weather {
                //self.weatherService.languages = languageList.data.languages
                self.weatherService.weathers = weather.query.results.channel
                
            } else {
                // Alert
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
}
