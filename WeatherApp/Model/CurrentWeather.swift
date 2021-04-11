//
//  CurrentWeather.swift
//  weatherApp
//
//  Created by yeonBlue on 2021/04/04.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    // MARK: - Vars
    var city: String!
    var date: Date!
    var currentTemperature: Double!
    var feelsLikeTemperature: Double!
    var uvIndex: Double! // Ultraviolet index - 햇볕을 쬐는 자외선의 강도를 측정하는 국제 표준
    
    var weatherType: String!
    var pressure: Double! // 기압 밀리파스칼 (mpa)
    var humidity: Double! // %
    var windSpeed: Double! // m/s
    var weatherIcon: String!
    
    var visibility: Double! // in KM
    var sunrise: String!
    var sunset: String! // 일출 시간
    
    // MARK: - Functions
    func getCurrentWeather(location: WeatherLocation, completion: @escaping(Bool) -> Void) {
        
        var LOCATION_API_URL: String
        
        if !location.isCurrentLocation {
            LOCATION_API_URL = String(format: "https://api.weatherbit.io/v2.0/current?city=%@,%@&key=4369fd2fcad24f21b39355af07074845", location.city, location.countryCode)
        } else {
            LOCATION_API_URL = CURRENT_LOCATION_URL
        }
        
        AF.request(LOCATION_API_URL).responseJSON { response in
            let result = response.result
            
            switch result {
            case .success(let value):
                let json = JSON(value)
                
                self.city = json["data"][0]["city_name"].string
                self.date = curentDateFromTimestamp(doubleDate: json["data"][0]["ts"].double)
                self.currentTemperature = json["data"][0]["temp"].double
                self.feelsLikeTemperature = json["data"][0]["app_temp"].double
                self.uvIndex = json["data"][0]["city_name"].double
                
                self.weatherType = json["data"][0]["weather"]["description"].string
                self.pressure = json["data"][0]["pres"].double
                self.humidity = json["data"][0]["rh"].double
                self.windSpeed = json["data"][0]["wind_spd"].double
                self.weatherIcon = json["data"][0]["weather"]["icon"].string

                self.visibility = json["data"][0]["vis"].double
                self.sunrise = json["data"][0]["sunrise"].string
                self.sunset = json["data"][0]["sunset"].string
                
                completion(true)
                
            case .failure(_):
                completion(false)
            }
        }
    }
}
