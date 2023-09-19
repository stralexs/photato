//
//  LoadingViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

protocol LoadingDisplayLogic: AnyObject {
    func displaySomething(viewModel: Loading.Something.ViewModel)
}

class LoadingViewController: UIViewController, LoadingDisplayLogic {
    
    //@IBOutlet private var nameTextField: UITextField!
    
    var interactor: LoadingBusinessLogic?
    var router: (NSObjectProtocol & LoadingRoutingLogic & LoadingDataPassing)?
    
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
        view.backgroundColor = .blue
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
        let request = Loading.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Loading.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = LoadingInteractor()
        let presenter = LoadingPresenter()
        let router = LoadingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
