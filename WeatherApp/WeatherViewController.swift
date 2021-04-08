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
        
        weatherView.currentWeather = CurrentWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
