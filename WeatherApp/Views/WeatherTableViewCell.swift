//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/10.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    
    // MARK: - IBOutlets
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    // MARK: - UITableViewCell
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Helpers
    func generateCell(forecast: WeeklyWeather) {
        dayNameLabel.text = forecast.date.dayOfWeek()
        weatherIconImageView.image = getWeatherIconForImage(forecast.weatherIcon)
        temperatureLabel.text = "\(forecast.temperature!)"
        
    }
    
}
