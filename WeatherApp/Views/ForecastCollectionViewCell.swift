//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/08.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func genearateCell(weather: HourlyWeather) {
        timeLabel.text = weather.date!.time()
        temperatureLabel.text = "\(weather.temperature!)"
        weatherIconImageView.image = getWeatherIconForImage(weather.weatherIcon)
    }
}
