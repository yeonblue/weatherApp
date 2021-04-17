//
//  MainWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/11.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func generateCell(cityInfo: CityInfo) {
        cityLabel.text = cityInfo.city
        cityLabel.adjustsFontSizeToFitWidth = true
        
        // TODO: 폰트 dynamic 처리
        temperatureLabel.text =
            String(format: "%.0f", cityInfo.temperature!) + returnTemperatureFormatFromUserDefaults()
        temperatureLabel.adjustsFontSizeToFitWidth = true
    }

}
