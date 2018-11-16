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
    @IBOutlet weak var weatherImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(city: String, temp: String, image: String) {
        cityLabel.text = city
        tempLabel.text = temp + " °"
        //weatherImageView.image = UIImage(named: image)
    }

}
