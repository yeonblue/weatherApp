//
//  GlobalHelpers.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/04.
//

import UIKit

func curentDateFromTimestamp(doubleDate date: Double?) -> Date? {
    guard let date = date else { return Date() }
    return Date(timeIntervalSince1970: date)
}

func getWeatherIconForImage(_ type: String) -> UIImage? {
    return UIImage(named: type)
}
