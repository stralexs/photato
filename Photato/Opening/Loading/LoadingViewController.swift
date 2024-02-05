//
//  LoadingViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

protocol LoadingDisplayLogic: AnyObject {
    func displaySignInResult(viewModel: Loading.SignInUser.ViewModel)
    func displayLocationsDownloadResult(viewModel: Loading.DownloadLocations.ViewModel)
}

class LoadingViewController: UIViewController, LoadingDisplayLogic {
    // MARK: - Properties
    private var interactor: LoadingBusinessLogic?
    private var router: (NSObjectProtocol & LoadingRoutingLogic)?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let appIconImageView: UIImageView = {
        let appIconImageView = UIImageView()
        appIconImageView.contentMode = .scaleAspectFill
        appIconImageView.image = UIImage(named: "PhotatoAppIcon")
        return appIconImageView
    }()
    
    private let loadingLabel: UILabel = {
        let loadingLabel = UILabel()
        loadingLabel.textColor = .tortilla
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading"
        loadingLabel.font = .systemFont(ofSize: 24, weight: .regular)
        return loadingLabel
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tuneConstraints()
        tuneUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signInUser()
    }
    
    // MARK: - Methods
    private func tuneConstraints() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(180)
        }
        stackView.addArrangedSubview(appIconImageView)
        stackView.addArrangedSubview(loadingLabel)
        stackView.addArrangedSubview(activityIndicator)
        stackView.spacing = 5
        
        appIconImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
        loadingLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    private func tuneUI() {
        activityIndicator.startAnimating()
    }
    
    private func configure() {
        let viewController = self
        let interactor = LoadingInteractor(keychainManager: KeychainManager(), firebaseManager: FirebaseManager())
        let presenter = LoadingPresenter()
        let router = LoadingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}

    // MARK: - SignInUser Use case
extension LoadingViewController {
    private func signInUser() {
        guard self.view.isHidden == false else { return }
        let request = Loading.SignInUser.Request()
        interactor?.signInUser(request: request)
    }
    
    func displaySignInResult(viewModel: Loading.SignInUser.ViewModel) {
        if viewModel.signInErrorDescription == nil {
            downloadLocations()
        } else {
            activityIndicator.stopAnimating()
            appIconImageView.isHidden = true
            loadingLabel.isHidden = true
            presentBasicAlert(title: viewModel.signInErrorDescription, message: nil, actions: [.okAction]) { _ in self.router?.routeToUserValidation() }
        }
    }
}

    // MARK: - DownloadLocations Use case
extension LoadingViewController {
    private func downloadLocations() {
        let request = Loading.DownloadLocations.Request()
        interactor?.downloadLocations(request: request)
    }
    
    func displayLocationsDownloadResult(viewModel: Loading.DownloadLocations.ViewModel) {
        if viewModel.downloadErrorDescription == nil {
            router?.routeToTabBarController()
        } else {
            presentBasicAlert(title: viewModel.downloadErrorDescription, message: nil, actions: [.okAction]) { _ in self.router?.routeToUserValidation() }
        }
    }
}
