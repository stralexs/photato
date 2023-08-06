//
//  LocationsListViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import SnapKit

protocol LocationsListDisplayLogic: AnyObject {
    func displayCourses(viewModel: LocationsList.FetchLocations.ViewModel)
}

class LocationsListViewController: UIViewController, LocationsListDisplayLogic {
    // MARK: - Variables
    var configurator: LocationsListConfigurator?
    var interactor: LocationsListBusinessLogic?
    var router: (NSObjectProtocol & LocationsListRoutingLogic & LocationsListDataPassing)?
    
    private var locations: [LocationsList.FetchLocations.ViewModel.DisplayedLocation] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.register(LocationsListTableViewCell.self, forCellReuseIdentifier: LocationsListTableViewCell.identifier)
        tableView.rowHeight = 140
        return tableView
    }()
    
    let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        return searchController
    }()
        
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator = LocationsListConfigurator()
        configurator?.configure(with: self)
        tuneUI()
        getLocations()
    }
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - Methods
    func tuneUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Список"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
    
    func getLocations() {
        let request = LocationsList.FetchLocations.Request()
        interactor?.fetchLocations(request: request)
    }
    
    func displayCourses(viewModel: LocationsList.FetchLocations.ViewModel) {
        locations = viewModel.displayedLocations
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

    // MARK: - UITableViewDataSource
extension LocationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationsListTableViewCell.identifier, for: indexPath) as? LocationsListTableViewCell else { return UITableViewCell() }
        let location = locations[indexPath.row]
        cell.configure(with: location)
        return cell
    }
}
    // MARK: -  UITableViewDelegate
extension LocationsListViewController: UITableViewDelegate {
    
}
