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
        
        let currentWeather = CurrentWeather()
        currentWeather.getCurrentWeather { success in
            if success {
                print(currentWeather.city!)
                print(currentWeather.currentTemperature!)
                print(currentWeather.feelsLikeTemperature!)
            }
        }
    }
}

