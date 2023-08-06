//
//  LocationsListViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import SnapKit

protocol LocationsListDisplayLogic: AnyObject {
    func displaySomething(viewModel: LocationsList.Something.ViewModel)
}

class LocationsListViewController: UIViewController, LocationsListDisplayLogic {
    
    //@IBOutlet private var nameTextField: UITextField!
    var configurator: LocationsListConfigurator?
    var interactor: LocationsListBusinessLogic?
    var router: (NSObjectProtocol & LocationsListRoutingLogic & LocationsListDataPassing)?
    
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
        
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator = LocationsListConfigurator()
        configurator?.configure(with: self)
        tuneUI()
        doSomething()
    }
    
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
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: Do something
    
    func doSomething() {
        let request = LocationsList.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: LocationsList.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

    // MARK: - UITableViewDataSource
extension LocationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationsListTableViewCell.identifier, for: indexPath) as? LocationsListTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
    
    
}
    // MARK: -  UITableViewDelegate
extension LocationsListViewController: UITableViewDelegate {
    
}
