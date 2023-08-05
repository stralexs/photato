//
//  LocationDescriptionViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationDescriptionDisplayLogic: AnyObject {
    func displaySomething(viewModel: LocationDescription.Something.ViewModel)
}

class LocationDescriptionViewController: UIViewController, LocationDescriptionDisplayLogic {
    
    //@IBOutlet private var nameTextField: UITextField!
    
    var interactor: LocationDescriptionBusinessLogic?
    var router: (NSObjectProtocol & LocationDescriptionRoutingLogic & LocationDescriptionDataPassing)?
    
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
        let request = LocationDescription.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: LocationDescription.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = LocationDescriptionInteractor()
        let presenter = LocationDescriptionPresenter()
        let router = LocationDescriptionRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
