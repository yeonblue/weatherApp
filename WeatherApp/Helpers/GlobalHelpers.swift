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


// MARK: - Temperature
func fahrenheitFromCelcius(celcius: Double) -> Double {
    let value = (celcius * 9/5) + 32
    return Double(String(format: "%.1f", value)) ?? 0.0
}

func getTemperatureBasedOnSetting(celsius: Double) -> Double {
    let format = returnTemperatureFormatFromUserDefaults()
    
    if format == TemperatureFormat.celcius {
        return celsius
    } else {
        return fahrenheitFromCelcius(celcius: celsius)
    }
}

func returnTemperatureFormatFromUserDefaults() -> String {
    if let temperatureFormat = UserDefaults.standard.value(forKey: kTEMPERATURE_FORMAT) as? Int{
        return temperatureFormat == 0 ? TemperatureFormat.celcius
                                      : TemperatureFormat.fahrenheit
    } else {
        return TemperatureFormat.celcius
    }
}
