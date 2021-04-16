//
//  WeatherView.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/06.
//

import UIKit

private let tableViewReuseIdentifier = "TableViewCell"
private let hourlyCollectionViewReuseIdentifier = "HourlyWeatherCollectionViewCell"
private let infoCollectionViewReuseIdentifier = "InfoCollectionViewCell"

class WeatherView: UIView {

    // MARK: - IBOuttet
    @IBOutlet weak var mainView: UIView!
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
    
    var weatherLocation: WeatherLocation! {
        willSet(newValue) {
            downloadWeatherDatas(newValue)
        }
    }
    
    var currentWeatherData: CurrentWeather?
    
    var weeklyWeatherForecastData = [WeeklyWeather]() {
        didSet{
            self.bottomTableView.reloadData()
        }
    }
    var dailyWeatherForcastData = [HourlyWeather]() {
        didSet{
            self.hourlyWeatherCollectionView.reloadData()
        }
    }
    var weatherInfoData = [WeatherInfo]() {
        didSet{
            self.infoCollectionView.reloadData()
        }
    }
    
    var cityInfo: CityInfo?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mainInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mainInit()
    }
    
    func mainInit() {

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
        bottomTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main),
                                 forCellReuseIdentifier: tableViewReuseIdentifier)
        bottomTableView.delegate = self
        bottomTableView.dataSource = self
        bottomTableView.tableFooterView = UIView()
    }
    
    private func setupHourlyCollectionView() {
        hourlyWeatherCollectionView.register(UINib(nibName: "ForecastCollectionViewCell",
                                                   bundle: Bundle.main),
                                             forCellWithReuseIdentifier: hourlyCollectionViewReuseIdentifier)
        hourlyWeatherCollectionView.dataSource = self
    }
    
    private func setupInfoCollectionView() {
        infoCollectionView.register(UINib(nibName: "InfoCollectionViewCell",
                                                   bundle: Bundle.main),
                                             forCellWithReuseIdentifier: infoCollectionViewReuseIdentifier)
        infoCollectionView.dataSource = self
    }
    
    private func setupCurrentWeather() {
        
        guard let currentWeather = currentWeatherData else { return }
        
        cityNameLabel.text = currentWeather.city
        dateLabel.text = "Today, \(currentWeather.date.shortDate())"
        weatherInfoLabel.text = currentWeather.weatherType
        temperatureLabel.text = String(describing: currentWeather.currentTemperature!)
        setupWeatherInfo()
        
        cityInfo = CityInfo(city: currentWeather.city!,
                            temperature: currentWeather.currentTemperature!)
    }
    
    private func setupWeatherInfo() {
        guard let info = currentWeatherData else { return }
        let windInfo = WeatherInfo(infoText: String(format: "%.1f m/sec", info.windSpeed!),
                                   nameText: nil,
                                   image: getWeatherIconForImage("wind"))
        
        let humidity = WeatherInfo(infoText: String(format: "%.0f", info.humidity!),
                                   nameText: nil,
                                   image: getWeatherIconForImage("humidity"))
        
        let pressureInfo = WeatherInfo(infoText: String(format: "%.0f mb", info.pressure!),
                                       nameText: nil,
                                       image: getWeatherIconForImage("pressure"))
        
        let visibilityInfo = WeatherInfo(infoText: String(format: "%.0f km", info.visibility!),
                                         nameText: nil,
                                         image: getWeatherIconForImage("visibility"))
        
        let feelsLike = WeatherInfo(infoText: String(format: "%.1f", info.feelsLikeTemperature!),
                                    nameText: nil,
                                    image: getWeatherIconForImage("feelsLike"))
        
        let uvInfo = WeatherInfo(infoText: String(format: "%.1f", info.uvIndex ?? 0.0),
                                 nameText: "UV Index",
                                 image: nil)
        
        let sunriseInfo = WeatherInfo(infoText: info.sunrise!,
                                      nameText: nil,
                                      image: getWeatherIconForImage("sunrise"))
        
        let sunset = WeatherInfo(infoText: info.sunset!,
                                 nameText: nil,
                                 image: getWeatherIconForImage("sunset"))
        
        weatherInfoData = [windInfo, humidity, pressureInfo, visibilityInfo,
                           feelsLike, uvInfo, sunriseInfo, sunset]
    }
    
    // MARK: - Functions
    
    func refreshData() {
        setupCurrentWeather()
    }
    
    private func downloadWeatherDatas(_ newValue: WeatherLocation) {
        currentWeatherData = CurrentWeather()
        currentWeatherData?.getCurrentWeather(location: newValue, completion: { success in
            if success {
                self.refreshData()
            }
        })
        
        WeeklyWeather.downloadWeeklyForecastWeather(location: newValue) { datas in
            self.weeklyWeatherForecastData = datas
        }
        
        HourlyWeather.downloadHourlyForecastWeather(location: newValue) { datas in
            self.dailyWeatherForcastData = datas
        }
    }
}

// MARK: - UITableViewDelegate/Datasource
extension WeatherView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeatherForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewReuseIdentifier,
                                                 for: indexPath) as! WeatherTableViewCell
        cell.generateCell(forecast: weeklyWeatherForecastData[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyWeatherCollectionView {
            return dailyWeatherForcastData.count
        } else {
            return weatherInfoData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyWeatherCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourlyCollectionViewReuseIdentifier,
                                                          for: indexPath) as! ForecastCollectionViewCell
            cell.genearateCell(weather: dailyWeatherForcastData[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCollectionViewReuseIdentifier,
                                                          for: indexPath) as! InfoCollectionViewCell
            cell.generateCell(weatherInfo: weatherInfoData[indexPath.row])
            return cell
        }
    }
}
