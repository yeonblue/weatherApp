//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/06.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var weatherScrollView: UIScrollView!
    @IBOutlet weak var weatherPageControl: UIPageControl!
    @IBOutlet weak var addWeatherButton: UIBarButtonItem!

    // MARK: - Properties
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    var userDefaults = UserDefaults.standard
    
    var allLocations = [WeatherLocation]()
    var allWeatherViews = [WeatherView]()
    var allWeatherData = [CityInfo]()
    
    var weatherView: WeatherView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerStart()
        
//        let frame = CGRect(x: 0,
//                           y: 0,
//                           width: weatherScrollView.bounds.width,
//                           height: weatherScrollView.bounds.height)
//
//        weatherView = WeatherView(frame: frame)
//
//        weatherView.weatherLocation = WeatherLocation(city: "Wonju",
//                                                      country: "Korea",
//                                                      countryCode: "KR",
//                                                      isCurrentLocation: false)
//        weatherScrollView.addSubview(weatherView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationAuthCheck()
        print(allLocations.count)
    }
    
    // MARK: - Location Manager
    private func locationManagerStart() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization() // Privacy - Location When In Use Usage Description
            locationManager!.delegate = self
        }
        
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    private func locationManagerStop() {
        if locationManager != nil {
            locationManager?.stopMonitoringSignificantLocationChanges()
        }
    }
    
    private func locationAuthCheck() {
        if CLLocationManager.authorizationStatus() != .denied {
            currentLocation = locationManager!.location?.coordinate
            
            if currentLocation != nil {
                // set coordinates
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.logitude = currentLocation.longitude
                locationManagerStop()
                
                getWeather()
            } else {
                locationAuthCheck()
            }
        } else {
            locationManager?.requestWhenInUseAuthorization()
            
            // 동의 하지 않으면 다시 묻기
            locationAuthCheck()
        }
    }
    
    // MARK: - Make Weather View
    private func getWeather() {
        loadLocationFromUserDefaults()
        createWeatherViews()
        addWeatherToScrollView()
    }
    
    private func createWeatherViews() {
        for _ in allLocations {
            allWeatherViews.append(WeatherView())
        }
    }
    
    private func addWeatherToScrollView() {
        for index in 0..<allWeatherViews.count {
            let weatherView = allWeatherViews[index]
            let location = allLocations[index]
            
            weatherView.weatherLocation = location
            
            let xPos = self.view.frame.width * CGFloat(index)
            
            weatherView.frame = CGRect(x: xPos,
                                       y: 0,
                                       width: weatherScrollView.bounds.width,
                                       height: weatherScrollView.bounds.height)
            
            weatherScrollView.addSubview(weatherView)
            weatherScrollView.contentSize.width = weatherView.frame.width * CGFloat(index + 1)
        }
    }

    // MARK: - UserDefaults(Weather Info)
    private func loadLocationFromUserDefaults() {
        let currentLocation = WeatherLocation(city: "",
                                              country: "",
                                              countryCode: "",
                                              isCurrentLocation: true)
        
        if let data = userDefaults.value(forKey: kLOCATION) as? Data {
            allLocations = try! PropertyListDecoder().decode([WeatherLocation].self, from: data)
            allLocations.insert(currentLocation, at: 0)
            print(allLocations.count)
            
        } else {
            print("DEBUG: No user data")
            allLocations.append(currentLocation)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location. \(error.localizedDescription)")
    }
}
