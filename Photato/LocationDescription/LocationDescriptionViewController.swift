//
//  LocationDescriptionViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationDescriptionDisplayLogic: AnyObject {
    func displayLocationDescription(viewModel: LocationDescription.ShowLocationDescription.ViewModel)
}

class LocationDescriptionViewController: UIViewController, LocationDescriptionDisplayLogic {
    // MARK: - Properties
    var interactor: LocationDescriptionBusinessLogic?
    var router: (NSObjectProtocol & LocationDescriptionRoutingLogic & LocationDescriptionDataPassing)?
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "OktyabrskayaStreet1")
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let locationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Lorem ipsum"
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let locationDescriptionHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Описание"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let locationDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 17, weight: .light)
        textView.layer.cornerRadius = 10
        textView.isEditable = false
        textView.backgroundColor = .darkOliveGreen
        return textView
    }()
    
    let locationAddressHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Адрес"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let locationAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let coordinatesBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .tortilla
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let locationCoordinatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "53.97528, 27.44942"
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let copyCoordinatesButton: UIButton = {
        let copyCoordinatesButton = UIButton()
        let image = UIImage(systemName: "square.on.square")
        copyCoordinatesButton.setImage(image, for: .normal)
        copyCoordinatesButton.imageView?.contentMode = .scaleAspectFit
        copyCoordinatesButton.contentHorizontalAlignment = .fill
        copyCoordinatesButton.contentVerticalAlignment = .fill
        copyCoordinatesButton.tintColor = .darkOliveGreen
        return copyCoordinatesButton
    }()
    
    let openInMapsButton: UIButton = {
        let openInMapsButton = UIButton()
        let image = UIImage(systemName: "location.circle")
        openInMapsButton.setImage(image, for: .normal)
        openInMapsButton.imageView?.contentMode = .scaleAspectFit
        openInMapsButton.contentHorizontalAlignment = .fill
        openInMapsButton.contentVerticalAlignment = .fill
        openInMapsButton.tintColor = .darkOliveGreen
        return openInMapsButton
    }()
    
    let downloadImageButton: UIButton = {
        let downloadImageButton = UIButton()
        let image = UIImage(systemName: "square.and.arrow.down")
        downloadImageButton.setImage(image, for: .normal)
        downloadImageButton.imageView?.contentMode = .scaleAspectFit
        downloadImageButton.contentHorizontalAlignment = .fill
        downloadImageButton.contentVerticalAlignment = .fill
        downloadImageButton.tintColor = .tortilla
        return downloadImageButton
    }()
    
    let addToFavouritesButton: UIButton = {
        let addToFavouritesButton = UIButton()
        let image = UIImage(systemName: "heart")
        addToFavouritesButton.setImage(image, for: .normal)
        addToFavouritesButton.imageView?.contentMode = .scaleAspectFit
        addToFavouritesButton.contentHorizontalAlignment = .fill
        addToFavouritesButton.contentVerticalAlignment = .fill
        addToFavouritesButton.tintColor = .tortilla
        return addToFavouritesButton
    }()

    // MARK: - Object Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLocationDescription()
        tuneUI()
    }
    
    // MARK: - Methods
    private func tuneUI() {
        view.backgroundColor = .lightTortilla
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(locationImageView)
        locationImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.35)
        }
        
        view.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(locationImageView.snp.bottom)
            make.right.equalToSuperview().inset(15)
            make.height.equalToSuperview().multipliedBy(0.07)
        }
        
        view.addSubview(coordinatesBackgroundView)
        coordinatesBackgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(locationNameLabel.snp.bottom)
            make.height.equalTo(40)
            make.width.equalTo(170)
        }
        
        coordinatesBackgroundView.addSubview(locationCoordinatesLabel)
        locationCoordinatesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(copyCoordinatesButton)
        copyCoordinatesButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.left.equalTo(coordinatesBackgroundView.snp.right).offset(15)
            make.centerY.equalTo(coordinatesBackgroundView.snp.centerY)
        }
        
        view.addSubview(openInMapsButton)
        openInMapsButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.left.equalTo(copyCoordinatesButton.snp.right).offset(15)
            make.centerY.equalTo(coordinatesBackgroundView.snp.centerY)
        }
        
        view.addSubview(locationAddressHeaderLabel)
        locationAddressHeaderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(coordinatesBackgroundView.snp.bottom).inset(-10)
        }
        
        view.addSubview(locationAddressLabel)
        locationAddressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(locationAddressHeaderLabel.snp.bottom).inset(-5)
        }
        
        view.addSubview(downloadImageButton)
        downloadImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalToSuperview().offset(-100)
        }
        
        view.addSubview(addToFavouritesButton)
        addToFavouritesButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalToSuperview().offset(100)
        }
        
        view.addSubview(locationDescriptionHeaderLabel)
        locationDescriptionHeaderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(locationNameLabel.snp.bottom).offset(100)
        }
        
        view.addSubview(locationDescriptionTextView)
        locationDescriptionTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(locationDescriptionHeaderLabel.snp.bottom).inset(-5)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(downloadImageButton.snp.top).offset(-10)
        }
    }
    
    func showLocationDescription() {
        let request = LocationDescription.ShowLocationDescription.Request()
        interactor?.showLocationDescription(request: request)
    }
    
    func displayLocationDescription(viewModel: LocationDescription.ShowLocationDescription.ViewModel) {
        guard let imageData = viewModel.displayedLocation.imagesData.first else { return }
        locationImageView.image = UIImage(data: imageData)
        locationNameLabel.text = viewModel.displayedLocation.name
        locationAddressLabel.text = viewModel.displayedLocation.address
        locationDescriptionTextView.text = viewModel.displayedLocation.description
        locationCoordinatesLabel.text = viewModel.displayedLocation.coordinates
    }
    
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
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
}
