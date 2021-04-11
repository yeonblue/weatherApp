//
//  WeatherInfo.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/09.
//

import UIKit

struct WeatherInfo {
    var infoText: String!
    var nameText: String?
    var image: UIImage?
}

struct WeatherLocation {
    var city: String!
    var country: String!
    var countryCode: String!
    var isCurrentLocation: Bool!
}
