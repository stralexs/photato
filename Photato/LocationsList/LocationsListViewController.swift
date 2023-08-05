//
//  LocationsListViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationsListDisplayLogic: AnyObject {
    func displaySomething(viewModel: LocationsList.Something.ViewModel)
}

class LocationsListViewController: UIViewController, LocationsListDisplayLogic {
    
    //@IBOutlet private var nameTextField: UITextField!
    
    var interactor: LocationsListBusinessLogic?
    var router: (NSObjectProtocol & LocationsListRoutingLogic & LocationsListDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
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
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = LocationsListInteractor()
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
