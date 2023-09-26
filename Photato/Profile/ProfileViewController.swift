//
//  ProfileViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {
    func displayUserFavouriteLocations(viewModel: Profile.GetUserFavouriteLocations.ViewModel)
    func displayUserData(viewModel: Profile.FetchUserData.ViewModel)
}

final class ProfileViewController: UIViewController, ProfileDisplayLogic {
    // MARK: - Properties
    var interactor: ProfileBusinessLogic?
    var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
    
    private var locations = [Location]()
    
    private let topContainerView: UIView = {
        let topContainerView = UIView()
        return topContainerView
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let profileImageViewContainerView: UIView = {
        let profileImageViewBackgroundView = UIView()
        profileImageViewBackgroundView.backgroundColor = .clear
        return profileImageViewBackgroundView
    }()
        
    private let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.darkOliveGreen.cgColor
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        return profileImageView
    }()
    
    private let settingsButton: UIButton = {
        let settingsButton = UIButton()
        let image = UIImage(systemName: "gear")
        settingsButton.setImage(image, for: .normal)
        settingsButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.contentHorizontalAlignment = .fill
        settingsButton.contentVerticalAlignment = .fill
        settingsButton.tintColor = .tortilla
        return settingsButton
    }()
    
    private let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textColor = .tortilla
        userNameLabel.textAlignment = .center
        userNameLabel.font = .systemFont(ofSize: 36, weight: .heavy)
        userNameLabel.text = "Username"
        userNameLabel.adjustsFontSizeToFitWidth = true
        return userNameLabel
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let tableViewLabelContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()
    
    private let tableViewLabel: UILabel = {
        let tableViewLabel = UILabel()
        tableViewLabel.textColor = .black
        tableViewLabel.textAlignment = .left
        tableViewLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        tableViewLabel.text = "Favorites"
        tableViewLabel.adjustsFontSizeToFitWidth = true
        return tableViewLabel
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableView.rowHeight = 140
        return tableView
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tuneUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserFavoriteLocations()
        fetchUserData()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Methods

    // MARK: GetUserFavouriteLocations Use case
    private func getUserFavoriteLocations() {
        let request = Profile.GetUserFavouriteLocations.Request()
        interactor?.getUserFavouriteLocations(request: request)
    }
    
    func displayUserFavouriteLocations(viewModel: Profile.GetUserFavouriteLocations.ViewModel) {
        locations = viewModel.locations
        tableView.reloadData()
    }
    
    // MARK: FetchUserData Use case
    private func fetchUserData() {
        let request = Profile.FetchUserData.Request()
        interactor?.fetchUserData(request: request)
    }
    
    func displayUserData(viewModel: Profile.FetchUserData.ViewModel) {
        let profilePicture = viewModel.image
        let name = viewModel.name
        
        profileImageView.image = profilePicture
        userNameLabel.text = name
    }
    
    // MARK: Other methods
    private func tuneUI() {
        view.backgroundColor = .lightTortilla

        navigationItem.backButtonTitle = "Profile"
        
        view.addSubview(topContainerView)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.tortilla.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.25)
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        topContainerView.addSubview(topStackView)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            topStackView.topAnchor.constraint(equalTo: topContainerView.topAnchor),
            topStackView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
        ])
        topStackView.addArrangedSubview(profileImageViewContainerView)
        topStackView.addArrangedSubview(userNameLabel)
        
        profileImageViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageViewContainerView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            profileImageViewContainerView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            profileImageViewContainerView.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.8)
        ])
        
        profileImageViewContainerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: profileImageViewContainerView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileImageViewContainerView.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalTo: profileImageViewContainerView.heightAnchor, multiplier: 0.65),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
        ])
        
        profileImageViewContainerView.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsButton.heightAnchor.constraint(equalToConstant: 30),
            settingsButton.widthAnchor.constraint(equalToConstant: 30),
            settingsButton.trailingAnchor.constraint(equalTo: profileImageViewContainerView.trailingAnchor, constant: -20),
            settingsButton.topAnchor.constraint(equalTo: profileImageViewContainerView.topAnchor, constant: 10)
        ])
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            userNameLabel.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.3)
        ])
        
        view.addSubview(bottomStackView)
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomStackView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor)
        ])
        
        bottomStackView.addArrangedSubview(tableViewLabelContainerView)
        tableViewLabelContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewLabelContainerView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor),
            tableViewLabelContainerView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor),
            tableViewLabelContainerView.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, multiplier: 0.1)
        ])
        
        tableViewLabelContainerView.addSubview(tableViewLabel)
        tableViewLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewLabel.widthAnchor.constraint(equalTo: tableViewLabelContainerView.widthAnchor),
            tableViewLabel.leadingAnchor.constraint(equalTo: tableViewLabelContainerView.leadingAnchor, constant: 10),
            tableViewLabel.trailingAnchor.constraint(equalTo: tableViewLabelContainerView.trailingAnchor, constant: 10),
            tableViewLabel.centerYAnchor.constraint(equalTo: tableViewLabelContainerView.centerYAnchor)
        ])
        
        bottomStackView.addArrangedSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, multiplier: 0.9)
        ])
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configure() {
        let viewController = self
        let interactor = ProfileInteractor(worker: ProfileWorker())
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell else { return UITableViewCell() }
        let location = locations[indexPath.row]
        cell.configure(with: location)
        return cell
    }
}

// MARK: -  UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToLocationDescription()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
