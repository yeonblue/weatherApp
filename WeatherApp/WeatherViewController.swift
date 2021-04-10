//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/06.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var weatherScrollView: UIScrollView!
    @IBOutlet weak var weatherPageControl: UIPageControl!
    @IBOutlet weak var addWeatherButton: UIBarButtonItem!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: weatherScrollView.bounds.width,
                           height: weatherScrollView.bounds.height)
        
        let weatherView = WeatherView(frame: frame)
        weatherScrollView.addSubview(weatherView)
        
        downloadTotalWeatherData(weatherView: weatherView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Helpers
    private func getCurrentWeather(weatherView: WeatherView) {
        weatherView.currentWeatherData = CurrentWeather()
    }
    
    private func getWeeklyWeather(weatherView: WeatherView) {
        WeeklyWeather.downloadWeeklyForecastWeather { weatherForecasts in
            weatherView.weeklyWeatherForecastData = weatherForecasts
        }
    }
    
    private func getHourlyWeather(weatherView: WeatherView) {
        HourlyWeather.downloadHourlyForecastWeather { weatherForecasts in
            weatherView.dailyWeatherForcastData = weatherForecasts
        }
    }
    
    func downloadTotalWeatherData(weatherView: WeatherView) {
        getCurrentWeather(weatherView: weatherView)
        getWeeklyWeather(weatherView: weatherView)
        getHourlyWeather(weatherView: weatherView)
    }
}
