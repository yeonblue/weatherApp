//
//  AllLocationsTableViewController.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/11.
//

import UIKit

private let reuseIdentifier = "TableViewCell"

protocol AllLocationsTableViewControllerDelegate: class {
    func didChooseLocation(atIndex index: Int, shouldRefresh: Bool)
}

class AllLocationsTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var temperatureSegmentedControl: UISegmentedControl!
    
    // MARK: - IBActions
    @IBAction func tempertureSegmentValueChanged(_ sender: UISegmentedControl) {
        updateTempertureFormatInUserDefaults(index: sender.selectedSegmentIndex)
    }
    
    
    // MARK: - Properties
    let userDefaults = UserDefaults.standard
    var savedLocation: [WeatherLocation]?
    var cityInfoData: [CityInfo]? {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: AllLocationsTableViewControllerDelegate?
    var shouldRefresh: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLocationsFromUserDefaults()
        loadTempertureFormatFromUserDefaults()
    }
    
    // MARK: - UserDefaults
    private func loadLocationsFromUserDefaults() {
        if let data = userDefaults.value(forKey: kLOCATION) as? Data {
            savedLocation = try? PropertyListDecoder().decode([WeatherLocation].self, from: data)
        }
    }
    
    private func saveNewLocationsToUserDefaults() {
        
        shouldRefresh = true
        userDefaults.setValue(try? PropertyListEncoder().encode(savedLocation!), forKey: kLOCATION)
        userDefaults.synchronize()
    }
    
    private func loadTempertureFormatFromUserDefaults() {
        guard let idx = userDefaults.value(forKey: kTEMPERATURE_FORMAT) as? Int else { return }
        temperatureSegmentedControl.selectedSegmentIndex = idx
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseLocationSeque" {
            let destVC = segue.destination as! ChooseCityViewController
            destVC.delegate = self
        }
    }
    
    // MARK: - Helpers
    private func removeLocationFromSavedLocations(location: String) {
        guard savedLocation != nil else { return }
             
        for i in 0..<savedLocation!.count {
            let tempLocation = savedLocation![i]
            
            if tempLocation.city == location {
                savedLocation!.remove(at: i)
                return
            }
        }
    }
    
    private func updateTempertureFormatInUserDefaults(index idx: Int) {
        shouldRefresh = true
        userDefaults.setValue(idx, forKey: kTEMPERATURE_FORMAT)
        userDefaults.synchronize()
    }
}

// MARK: - UITableViewDelegate/Datasource
extension AllLocationsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityInfoData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! MainWeatherTableViewCell
        if cityInfoData != nil {
            cell.generateCell(cityInfo: (cityInfoData![indexPath.row]))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didChooseLocation(atIndex: indexPath.row, shouldRefresh: shouldRefresh)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 // 현재 위치 삭제 불가
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let locationToDelete = cityInfoData?[indexPath.row] else { return }
            cityInfoData?.remove(at: indexPath.row)
            
            removeLocationFromSavedLocations(location: locationToDelete.city)
            tableView.reloadData()
            
            // UserDefaults에서도 제거
            saveNewLocationsToUserDefaults()
        }
    }
}

// MARK: - ChooseCityViewControllerDelegate
extension AllLocationsTableViewController: ChooseCityViewControllerDelegate {
    func didWeatherLocationAdd(newLocation location: WeatherLocation) {
        shouldRefresh = true
        cityInfoData?.append(CityInfo(city: location.city,
                                      temperature: 0.0))
        print("DEBUG: City Added", location.city!)
    }
}
