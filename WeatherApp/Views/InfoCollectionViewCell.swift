//
//  InfoCollectionViewCell.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/09.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {

    
    // MARK: - IBOutlets
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Heleprs
    func generateCell(weatherInfo: WeatherInfo) {
        infoLabel.text = weatherInfo.infoText
        infoLabel.adjustsFontSizeToFitWidth = true
        
        if weatherInfo.image != nil {
            nameLabel.isHidden = true
            weatherIconImageView.isHidden = false
            
            weatherIconImageView.image = weatherInfo.image
        } else {
            nameLabel.isHidden = false
            weatherIconImageView.isHidden = true
            
            nameLabel.text = weatherInfo.nameText
            nameLabel.adjustsFontSizeToFitWidth = true
        }
    }
}
