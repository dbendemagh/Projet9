//
//  WeatherTableViewCell.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 12/11/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(city: String, temp: String, description: String, imageId: Int) {
        cityLabel.text = city
        tempLabel.text = "\(temp)°"
        descriptionLabel.text = description
        weatherImageView.image = UIImage(named: getImage(id: imageId))
    }

    func getImage(id: Int) -> String {
        switch id {
        case 200...232:
            return "11d.png"
        case 300...321, 520...531:
            return "09d.png"
        case 500...504:
            return "10d.png"
        case 600...622:
            return "13d.png"
        case 701...781:
            return "50d.png"
        case 800:
            return "01d.png"
        case 801:
            return "02d.png"
        case 802:
            return "03d.png"
        case 803...804:
            return "04d.png"
        default:
            return "na.png"
        }
    }
}
