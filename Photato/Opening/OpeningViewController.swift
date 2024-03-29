//
//  OpeningViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol OpeningDisplayLogic: AnyObject {
    func displayIsUserLoggedIn(viewModel: Opening.CheckIsUserLoggedIn.ViewModel)
}

final class OpeningViewController: UIViewController, OpeningDisplayLogic {
    // MARK: - Properties
    private var interactor: OpeningBusinessLogic?
    
    private let userValidationViewController = UserValidationViewController()
    private let loadingViewController = LoadingViewController()
    private let networkMonitor = NetworkConnectionMonitor()

    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupOpeningContainerScene()
        tuneUI()
        checkIsUserLoggedIn()
    }
    
    // MARK: - Methods
    private func setupOpeningContainerScene() {
        addChild(userValidationViewController)
        addChild(loadingViewController)
        view.addSubview(userValidationViewController.view)
        view.addSubview(loadingViewController.view)
        
        userValidationViewController.didMove(toParent: self)
        loadingViewController.didMove(toParent: self)
        
        userValidationViewController.view.frame = self.view.bounds
        loadingViewController.view.frame = self.view.bounds
        
        userValidationViewController.view.isHidden = true
        loadingViewController.view.isHidden = true
        
        networkMonitor.delegate = self
    }
    
    private func tuneUI() {
        navigationController?.navigationBar.tintColor = .tortilla
    }
    
    private func configure() {
        let viewController = self
        let interactor = OpeningInteractor()
        let presenter = OpeningPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
}

    // MARK: - CheckIsUserLoggedIn Use case
extension OpeningViewController {
    private func checkIsUserLoggedIn() {
        let request = Opening.CheckIsUserLoggedIn.Request()
        interactor?.checkIsUserLoggedIn(request: request)
    }
    
    func displayIsUserLoggedIn(viewModel: Opening.CheckIsUserLoggedIn.ViewModel) {
        DispatchQueue.main.async {
            let isUserLoggedIn = viewModel.isUserLoggedIn
            
            if isUserLoggedIn {
                self.loadingViewController.view.isHidden = false
            } else {
                self.userValidationViewController.view.isHidden = false
            }
        }
    }
}

    // MARK: - NetworkConnectionStatusDelegate
extension OpeningViewController: NetworkConnectionStatusDelegate {}
