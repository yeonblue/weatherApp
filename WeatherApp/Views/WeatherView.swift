//
//  WeatherView.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/06.
//

import UIKit

class WeatherView: UIView {

    // MARK: - IBOultet

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var bottomTableView: UITableView!
    
    // MARK: - Properties
    var currentWeather: CurrentWeather? {
        didSet {
            currentWeather?.getCurrentWeather(completion: { success in
                if success {
                    self.refreshDate()
                }
            })
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        mainInit()
    }
    
    private func mainInit() {
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupTableView()
        setupHourlyCollectionView()
        setupInfoCollectionView()
    }
    
    // MARK: - Helpers
    private func setupTableView() {
        
    }
    
    private func setupHourlyCollectionView() {
        
    }
    
    private func setupInfoCollectionView() {
        
    }
    
    private func setupCurrentWeather() {
        
        guard let currentWeather = currentWeather else { return }
        
        cityNameLabel.text = currentWeather.city
        dateLabel.text = "Today, \(currentWeather.date.shortDate())"
        weatherInfoLabel.text = currentWeather.weatherType
        temperatureLabel.text = String(describing: currentWeather.currentTemperature!)
    }
    
    // MARK: - Functions
    
    func refreshDate() {
        setupCurrentWeather()
    }
    
}
