//
//  WeatherVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var weatherService = WeatherService()
    
    // MARK: - Init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.tableFooterView = UIView()
        getWeather()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getWeather()
    }
    
    // MARK: - Methods
    
    func getWeather() {
        guard let request = weatherService.createWeatherRequest() else { return }
        
        toggleActivityIndicator(shown: true)
        weatherService.get(request: request) { (success, weather: Weather?) in
            self.toggleActivityIndicator(shown: false)
            if success, let weather = weather {
                self.weatherService.weathers = weather.query.results.channel
                self.weatherTableView.reloadData()
            } else {
                self.displayAlert(title: "Network error", message: "Cannot retrieve weather")
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
}

extension WeatherVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherService.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let weather = weatherService.weathers[indexPath.row]
        
        let date = weather.item.condition.date.split(separator: " ")
        let time = "\(date[4]) \(date[5])"
        cell.configure(city: weather.location.city, temp: weather.item.condition.temp, description: weather.item.condition.text, time: time, image: weather.item.condition.code)
        
        return cell
    }
}
