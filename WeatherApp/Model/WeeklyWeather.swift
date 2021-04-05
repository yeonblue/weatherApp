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
        self.temperature = json["temp"].double
        self.weatherIcon = json["weather"]["icon"].string
    }
    
    class func downloadWeeklyForecastWeather(completion: @escaping([WeeklyWeather]) -> Void) {
        
        let WEEKLY_FORCAST_URL = "https://api.weatherbit.io/v2.0/forecast/daily?city=Seoul,KR&days=7&key=4369fd2fcad24f21b39355af07074845"
        
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
