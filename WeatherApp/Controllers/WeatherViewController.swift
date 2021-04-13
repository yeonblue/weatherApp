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
    var allWeatherView = [WeatherView]()
    var allWeatherData = [CityInfo]()
    
    var weatherView: WeatherView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerStart()
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: weatherScrollView.bounds.width,
                           height: weatherScrollView.bounds.height)
        
        weatherView = WeatherView(frame: frame)
        weatherView.weatherLocation = WeatherLocation(city: "Wonju",
                                                      country: "Korea",
                                                      countryCode: "KR",
                                                      isCurrentLocation: false)
        weatherScrollView.addSubview(weatherView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationAuthCheck()
    }
    
    // MARK: - Location Manager
    private func locationManagerStart() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestWhenInUseAuthorization() // Privacy - Location When In Use Usage Description
            locationManager?.delegate = self
        }
        
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    private func locationManagerStop() {
        if locationManager != nil {
            locationManager?.stopMonitoringSignificantLocationChanges()
        }
    }
    
    private func locationAuthCheck() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            currentLocation = locationManager?.location?.coordinate
            if currentLocation != nil {
                // set coordinates
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.logitude = currentLocation.longitude
                
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
    
    // MARK: - Helpers
    private func getWeather() {
        loadLocationFromUserDefaults()
    }

    // MARK: - UserDefaults(Weather Info)
    private func loadLocationFromUserDefaults() {
        var currentLocation = WeatherLocation(city: "",
                                              country: "",
                                              countryCode: "",
                                              isCurrentLocation: true)
        
        if let data = userDefaults.value(forKey: kLOCATION) as? Data {
            allLocations = try! PropertyListDecoder().decode([WeatherLocation].self, from: data)
            allLocations.insert(currentLocation, at: 0)
            
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
