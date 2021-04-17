//
//  WeeklyForcastModel.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/05.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeeklyWeather {
    
    var date: Date!
    var temperature: Double!
    var weatherIcon: String!
    
    init(weatherDictionary: Dictionary<String, AnyObject>) {
        let json = JSON(weatherDictionary)
        
        self.date = curentDateFromTimestamp(doubleDate: json["ts"].double)
        self.temperature =
            getTemperatureBasedOnSetting(celsius: json["temp"].double ?? 0.0) 
        self.weatherIcon = json["weather"]["icon"].string
    }
    
    class func downloadWeeklyForecastWeather(location: WeatherLocation, completion: @escaping([WeeklyWeather]) -> Void) {
        
        var WEEKLY_FORCAST_URL: String
        if !location.isCurrentLocation {
            WEEKLY_FORCAST_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&days=7&key=4369fd2fcad24f21b39355af07074845", location.city, location.countryCode)
        } else {
            WEEKLY_FORCAST_URL = CURRENT_LOCATION_WEEKLY_FORECAST_URL
        }
        
        
        
        AF.request(WEEKLY_FORCAST_URL).responseJSON { response in
            let result = response.result
            var forecastArray = [WeeklyWeather]()
            
            switch result {
            
            case .success(let value):
                guard let json = value as? Dictionary<String, AnyObject> else { return }
                var list = json["data"] as! [Dictionary<String, AnyObject>]
                list.remove(at: 0) // 오늘 날짜는 제거
                
                for item in list {
                    let forecast = WeeklyWeather(weatherDictionary: item)
                    forecastArray.append(forecast)
                }
                completion(forecastArray)
            case .failure(let error):
                print(error.localizedDescription)
                completion(forecastArray)
            }
        }  
    }
}
