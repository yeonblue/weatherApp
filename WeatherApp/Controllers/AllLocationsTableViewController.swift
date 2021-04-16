//
//  AllLocationsTableViewController.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/11.
//

import UIKit

private let reuseIdentifier = "TableViewCell"

class AllLocationsTableViewController: UITableViewController {

    // MARK: - Properties
    let userDefaults = UserDefaults.standard
    var savedLocation: [WeatherLocation]?
    var cityInfoData: [CityInfo]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLocationsFromUserDefaults()
    }
    
    // MARK: - UserDefaults
    private func loadLocationsFromUserDefaults() {
        if let data = userDefaults.value(forKey: kLOCATION) as? Data {
            savedLocation = try? PropertyListDecoder().decode([WeatherLocation].self, from: data)
        }
    }
    
    private func saveNewLocationsToUserDefaults() {
        userDefaults.setValue(try? PropertyListEncoder().encode(savedLocation!), forKey: kLOCATION)
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
        print("added", location.city!)
    }
}
