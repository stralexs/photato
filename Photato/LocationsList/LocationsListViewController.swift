//
//  LocationsListViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import SnapKit

protocol LocationsListDisplayLogic: AnyObject {
    func displayLocations(viewModel: LocationsList.FetchLocations.ViewModel)
    func displaySearchedLocations(viewModel: LocationsList.SearchLocations.ViewModel)
    func displayRefreshedLocations(viewModel: LocationsList.RefreshLocations.ViewModel)
}

final class LocationsListViewController: UIViewController, LocationsListDisplayLogic {
    // MARK: - Properties
    var interactor: LocationsListBusinessLogic?
    var router: (NSObjectProtocol & LocationsListRoutingLogic & LocationsListDataPassing)?
    
    private var locations = [Location]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.register(LocationsListTableViewCell.self, forCellReuseIdentifier: LocationsListTableViewCell.identifier)
        tableView.rowHeight = 140
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .tortilla
        return searchController
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: self)
        tuneUI()
        getLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLocations()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - Methods
    
    // MARK: FetchLocations Use case
    private func getLocations() {
        let request = LocationsList.FetchLocations.Request()
        interactor?.fetchLocations(request: request)
    }
    
    func displayLocations(viewModel: LocationsList.FetchLocations.ViewModel) {
        locations = viewModel.locations
        tableView.reloadData()
    }
    
    // MARK: SearchLocations Use case
    func displaySearchedLocations(viewModel: LocationsList.SearchLocations.ViewModel) {
        locations = viewModel.locations
        tableView.reloadData()
    }
    
    // MARK: RefreshLocations Use case
    func refreshLocations() {
        let request = LocationsList.RefreshLocations.Requst()
        interactor?.refreshLocations(requst: request)
    }
    
    func displayRefreshedLocations(viewModel: LocationsList.RefreshLocations.ViewModel) {
        locations = viewModel.locations
        tableView.reloadData()
    }
    
    // MARK: Other methods
    private func tuneUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Локации"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
    }
    
    private func configure(with view: LocationsListViewController) {
        let viewController = view
        let interactor = LocationsListInteractor(worker: LocationsListWorker())
        let presenter = LocationsListPresenter()
        let router = LocationsListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToLocationDescription()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
    
    // MARK: - UISearchBarDelegate
extension LocationsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request = LocationsList.SearchLocations.Request(searchText: searchText)
        interactor?.searchLocations(request: request)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getLocations()
    }
}
