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
    var shouldRefresh: Bool = true
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManagerStart()
        weatherScrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if shouldRefresh {
            allLocations = []
            allWeatherViews = []
            locationAuthCheck()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManagerStop()
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
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
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
        setPageControllPageNumber()
    }
    
    private func createWeatherViews() {
        for _ in allLocations {
            allWeatherViews.append(WeatherView())
        }
    }
    
    private func addWeatherToScrollView() {
        for idx in 0..<allWeatherViews.count {
            let weatherView = allWeatherViews[idx]
            let location = allLocations[idx]
            
            weatherView.weatherLocation = location
            
            let xPos = self.view.frame.width * CGFloat(idx)
            
            weatherView.frame = CGRect(x: xPos,
                                       y: 0,
                                       width: weatherScrollView.bounds.width,
                                       height: weatherScrollView.bounds.height)
            
            weatherScrollView.addSubview(weatherView)
            weatherScrollView.contentSize.width = weatherView.frame.width * CGFloat(idx + 1)
        }
    }
    
    private func generateWeatherList() {
        allWeatherData = []
        for weatherView in allWeatherViews {
            allWeatherData.append(CityInfo(city: weatherView.cityInfo?.city,
                                           temperature: weatherView.cityInfo?.temperature))
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allLocationSegue" {
            generateWeatherList()
            let vc = segue.destination as! AllLocationsTableViewController
            vc.cityInfoData = allWeatherData
            vc.delegate = self
        }
    }

    // MARK: - PageController
    private func setPageControllPageNumber() {
        weatherPageControl.numberOfPages = allWeatherViews.count
    }
    
    private func updatePageControlSelectedPage(currentPage page: Int) {
        weatherPageControl.currentPage = page
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

// MARK: - UIScrollViewDelegate
extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.width
        updatePageControlSelectedPage(currentPage: Int(round(value)))
    }
}

// MARK: - AllLocationsTableViewControllerDelegate
extension WeatherViewController: AllLocationsTableViewControllerDelegate {
    func didChooseLocation(atIndex index: Int, shouldRefresh: Bool) {
        let viewNumber = CGFloat(index)
        let newOffset = CGPoint(x: (weatherScrollView.frame.width + 1) * viewNumber, y: 0)
        
        weatherScrollView.setContentOffset(newOffset, animated: true)
        updatePageControlSelectedPage(currentPage: index)
        
        self.shouldRefresh = shouldRefresh
    }
}
