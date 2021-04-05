//
//  ViewController.swift
//  weatherApp
//
//  Created by yeonBlue on 2021/04/04.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeeklyWeather.downloadWeeklyForecastWeather { weeklyForcastArray in
            for data in weeklyForcastArray {
                print(data.date!, data.temperature!, data.weatherIcon!)
            }
        }
    }
}
