//
//  ChooseCityViewController.swift
//  WeatherApp
//
//  Created by yeonBlue on 2021/04/11.
//

import UIKit

private let reuseIdentifier = "TableViewCell"

protocol ChooseCityViewControllerDelegate: class {
    func didWeatherLocationAdd(newLocation location: WeatherLocation)
}

class ChooseCityViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var allLocations = [WeatherLocation]()
    var filteredLocations = [WeatherLocation]()
    var searchController = UISearchController()
    
    let userDefaults = UserDefaults.standard
    var savedLocation: [WeatherLocation]?
    
    weak var delegate: ChooseCityViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()
        
        loadLocationsFromCSV()
        setupTapGestureForDismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFromUserDefaults()
    }
    
    // MARK: - Helpers
    private func setupSearchController() {

        
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater = self
        
        // dimsBackgroundDuringPresentation는 deprecated
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = .prominent // 항상 visible
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage() // background 제거용
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .lightGray
    }
    
    private func setupTableView() {
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
    }
    
    private func setupTapGestureForDismiss() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleTableViewDismiss))
       
        // 뷰 추가 후 gestureRecognizer 추가 필요
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    private func chooseCityViewDismiss() {
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Selectors
    @objc private func handleTableViewDismiss() {
        chooseCityViewDismiss()
    }
    
    // MARK: - Get Locations Functions
    private func loadLocationsFromCSV() {
        guard let path = Bundle.main.path(forResource: "location", ofType: "csv") else { return }
        parseCSVAt(url: URL(fileURLWithPath: path))
    }
    
    private func parseCSVAt(url: URL?) {
        guard let url = url else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArr = dataEncoded?
                .components(separatedBy: "\n")
                .map({$0.components(separatedBy: ",")}) {
                
                for (row, line) in dataArr.enumerated() {
                    if ( row > 0 && line.count > 1 ) {
                        let weatherLocation = createLocation(line: line)
                        allLocations.append(weatherLocation)
                    }
                }
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func createLocation(line: [String]) -> WeatherLocation {
        return  WeatherLocation(city: line[0],
                                country: line[1],
                                countryCode: line[2],
                                isCurrentLocation: false)
    }
    
    // MARK: - UserDefault
    private func saveToUserDefaults(location: WeatherLocation) {
        if savedLocation != nil {
            if !savedLocation!.contains(location) {
                savedLocation!.append(location)
            }
        } else {
            savedLocation = [location]
        }
        
        // model을 userdefault에 저장할 시 PropertyListEncoder/Decoder 사용
        // 그 외는
        // UserDefaults.standard.set(25, forKey: "Age")
        // let age = defaults.integer(forKey: "Age") 이후 userDefaults.synchronize()
        
        userDefaults.set( try! PropertyListEncoder().encode(savedLocation!), forKey: kLOCATION)
        userDefaults.synchronize()
    }
    
    private func loadFromUserDefaults() {
        if let data = userDefaults.value(forKey: kLOCATION) as? Data {
            savedLocation = try? PropertyListDecoder().decode([WeatherLocation].self, from: data)
        }
    }
}

// MARK: - UITableViewDelegate/Datasource
extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath)
        
        let location = filteredLocations[indexPath.row]
        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        saveToUserDefaults(location: filteredLocations[indexPath.row])
        
        chooseCityViewDismiss()
    }
}

// MARK: - UISearchResultsUpdating
extension ChooseCityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContentForSearchText(searchText: searchText)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredLocations = allLocations.filter({ weatherLocation -> Bool in
            return weatherLocation.city.lowercased().contains(searchText.lowercased())
                || weatherLocation.country.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}
