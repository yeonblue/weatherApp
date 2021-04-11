//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/05.
//

import Foundation
import Alamofire
import SwiftyJSON

class HourlyWeather {
    
    var date: Date!
    var temperature: Double!
    var weatherIcon: String!
    
    init(weatherDictionary: Dictionary<String, AnyObject>) {
        let json = JSON(weatherDictionary)
        
        self.date = curentDateFromTimestamp(doubleDate: json["ts"].double)
        self.temperature = json["temp"].double
        self.weatherIcon = json["weather"]["icon"].string
    }
    
    class func downloadHourlyForecastWeather(location: WeatherLocation, completion: @escaping([HourlyWeather]) -> Void) {
        let HOURLY_FORCAST_URL: String
        
        if !location.isCurrentLocation {
            HOURLY_FORCAST_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/hourly?city=%@,%@&hours=24&key=4369fd2fcad24f21b39355af07074845", location.city, location.countryCode)
        } else {
            HOURLY_FORCAST_URL = CURRENT_LOCATION_HOURLY_FORECAST_URL
        }
        
        
        AF.request(HOURLY_FORCAST_URL).responseJSON { response in
            let result = response.result
            var forecastArray = [HourlyWeather]()
            
            switch result {
            case .success(let value):
                guard let json = value as? Dictionary<String, AnyObject> else { return }
                let list = json["data"] as! [Dictionary<String, AnyObject>]
                
                for item in list {
                    let forcast = HourlyWeather(weatherDictionary: item)
                    forecastArray.append(forcast)
                }
                
                completion(forecastArray)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
