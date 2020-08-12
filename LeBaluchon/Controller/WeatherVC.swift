//
//  WeatherVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var weatherService = WeatherService()
    let locationManager = CLLocationManager()
    
    // MARK: - Init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.tableFooterView = UIView()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadTableView()
    }
    
    // MARK: - Methods
    
    private func loadTableView() {
        weatherService.weathers = []
        getWeather(city: "New York", country: "us")
        locationManager.requestLocation()
    }
    
    private func getWeather(city: String, country: String) {
        if let request = weatherService.createWeatherRequest(city, country) {
            toggleActivityIndicator(shown: true)
            weatherService.get(request: request) { (success, weather: WeatherData?) in
                self.toggleActivityIndicator(shown: false)
                if success, let weather = weather {
                    self.addWeather(weatherData: weather)
                    self.weatherTableView.reloadData()
                } else {
                    self.displayAlert(title: "Network error", message: "Cannot retrieve weather")
                }
            }
        }
    }
    
    private func getWeather(latitude: Double, longitude: Double) {
        if let request = weatherService.createWeatherRequest(latitude, longitude) {
            toggleActivityIndicator(shown: true)
            weatherService.get(request: request) { (success, weather: WeatherData?) in
                self.toggleActivityIndicator(shown: false)
                if success, let weather = weather {
                    self.addWeather(weatherData: weather)
                    self.weatherTableView.reloadData()
                } else {
                    self.displayAlert(title: "Network error", message: "Cannot retrieve weather")
                }
            }
        }
    }
    
    private func addWeather(weatherData: WeatherData) {
        if let weather = weatherData.weather.last {
            let weatherModel = WeatherModel(id: weather.id, city: weatherData.name, temperature: weatherData.main.temp, description: weather.description)
            weatherService.weathers.append(weatherModel)
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
}

// MARK: - Table View Delegate

extension WeatherVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherService.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let weather = weatherService.weathers[indexPath.row]
        
        //let date = weather.item.condition.date.split(separator: " ")
        //let time = "\(date[4]) \(date[5])"
        cell.configure(city: weather.city,
                       temp: String(weather.temperature),
                       description: weather.description,
                       imageId: weather.id)
        
        return cell
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = Double(location.coordinate.latitude)
            let lon = Double(location.coordinate.longitude)
            getWeather(latitude: lat, longitude: lon)
            //weatherManager.fetchWeather(latitude: Doublelat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
