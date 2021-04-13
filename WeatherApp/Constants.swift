//
//  Constants.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/11.
//

import Foundation

let LM = LocationService.shared

var CURRENT_LOCATION_URL = "https://api.weatherbit.io/v2.0/current?lat=\(LM.latitude!)&lon=\(LM.logitude!)&key=4369fd2fcad24f21b39355af07074845"
var CURRENT_LOCATION_WEEKLY_FORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(LM.latitude!)&lon=\(LM.logitude!)&days=7&key=4369fd2fcad24f21b39355af07074845"
var CURRENT_LOCATION_HOURLY_FORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(LM.latitude!)&lon=\(LM.logitude!)&hours=24&key=4369fd2fcad24f21b39355af07074845"

let kLOCATION = "UserDefaultLocations"
