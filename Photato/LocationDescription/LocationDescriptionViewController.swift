//
//  LocationDescriptionViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationDescriptionDisplayLogic: AnyObject {
    func displayLocationDescription(viewModel: LocationDescription.ShowLocationDescription.ViewModel)
    func displayCopiedToClipboardMessage(viewModel: LocationDescription.CopyCoordinatesToClipboard.ViewModel)
    func displayLocationImagesCount(viewModel: LocationDescription.GetLocationImagesCount.ViewModel)
    func displayLocationAllImages(viewModel: LocationDescription.GetLocationAllImages.ViewModel)
}

final class LocationDescriptionViewController: UIViewController, LocationDescriptionDisplayLogic {
    // MARK: - Properties
    var interactor: LocationDescriptionBusinessLogic?
    var router: (NSObjectProtocol & LocationDescriptionRoutingLogic & LocationDescriptionDataPassing)?
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .automatic
        return scrollView
    }()
    
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let locationDescriptionHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Описание"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let locationDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 17, weight: .light)
        textView.layer.cornerRadius = 10
        textView.isEditable = false
        textView.backgroundColor = .darkOliveGreen
        return textView
    }()
    
    private let locationAddressHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Адрес"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let locationAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let coordinatesBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .tortilla
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let locationCoordinatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var copyCoordinatesButton: UIButton = {
        let copyCoordinatesButton = UIButton()
        let image = UIImage(systemName: "square.on.square")
        copyCoordinatesButton.setImage(image, for: .normal)
        copyCoordinatesButton.imageView?.contentMode = .scaleAspectFit
        copyCoordinatesButton.contentHorizontalAlignment = .fill
        copyCoordinatesButton.contentVerticalAlignment = .fill
        copyCoordinatesButton.addTarget(self, action: #selector(copyCoordinatesToClipboard), for: .touchUpInside)
        copyCoordinatesButton.tintColor = .darkOliveGreen
        return copyCoordinatesButton
    }()
    
    private lazy var openInMapsButton: UIButton = {
        let openInMapsButton = UIButton()
        let image = UIImage(systemName: "location.circle")
        openInMapsButton.setImage(image, for: .normal)
        openInMapsButton.imageView?.contentMode = .scaleAspectFit
        openInMapsButton.contentHorizontalAlignment = .fill
        openInMapsButton.contentVerticalAlignment = .fill
        openInMapsButton.addTarget(self, action: #selector(openLocationInMaps), for: .touchUpInside)
        openInMapsButton.tintColor = .darkOliveGreen
        return openInMapsButton
    }()
    
    private let copiedToClipboardMessageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .tortilla
        view.layer.cornerRadius = 20
        view.alpha = 0
        return view
    }()
    
    private let copiedToClipboardMessage: UILabel = {
        let message = UILabel()
        message.text = "Координаты скопированы"
        message.font = .systemFont(ofSize: 16, weight: .light)
        message.textAlignment = .center
        message.textColor = .white
        return message
    }()
    
    private let downloadImageButton: UIButton = {
        let downloadImageButton = UIButton()
        let image = UIImage(systemName: "sun.max")
        downloadImageButton.setImage(image, for: .normal)
        downloadImageButton.imageView?.contentMode = .scaleAspectFit
        downloadImageButton.contentHorizontalAlignment = .fill
        downloadImageButton.contentVerticalAlignment = .fill
        downloadImageButton.tintColor = .tortilla
        return downloadImageButton
    }()
    
    private let addToFavouritesButton: UIButton = {
        let addToFavouritesButton = UIButton()
        let image = UIImage(systemName: "heart")
        addToFavouritesButton.setImage(image, for: .normal)
        addToFavouritesButton.imageView?.contentMode = .scaleAspectFit
        addToFavouritesButton.contentHorizontalAlignment = .fill
        addToFavouritesButton.contentVerticalAlignment = .fill
        addToFavouritesButton.tintColor = .tortilla
        return addToFavouritesButton
    }()

    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLocationDescription()
        getLocationImagesCount()
        getLocationAllImages()
        tuneUI()
    }
    
    // MARK: - Methods
    
    // MARK: ShowLocationDescription Use case
    private func showLocationDescription() {
        let request = LocationDescription.ShowLocationDescription.Request()
        interactor?.showLocationDescription(request: request)
    }
    
    func displayLocationDescription(viewModel: LocationDescription.ShowLocationDescription.ViewModel) {
        locationNameLabel.text = viewModel.location.name
        locationAddressLabel.text = viewModel.location.address
        locationDescriptionTextView.text = viewModel.location.description
        locationCoordinatesLabel.text = viewModel.stringLocationCoordinates
    }
    
    // MARK: GetLocationImagesCount Use case
    private func getLocationImagesCount() {
        let request = LocationDescription.GetLocationImagesCount.Request()
        interactor?.getLocationImagesCount(request: request)
    }
    
    func displayLocationImagesCount(viewModel: LocationDescription.GetLocationImagesCount.ViewModel) {
        guard let imagesCount = viewModel.imagesCount else { return }
        pageControl.numberOfPages = imagesCount
    }
    
    // MARK: GetLocationAllImages Use case
    private func getLocationAllImages() {
        let request = LocationDescription.GetLocationAllImages.Request()
        interactor?.getLocationAllImages(request: request)
    }
    
    func displayLocationAllImages(viewModel: LocationDescription.GetLocationAllImages.ViewModel) {
        let imagesData = viewModel.imagesData
        let imagesCount = imagesData.count
        
        for x in 0..<imagesCount {
            let imageView = UIImageView()
            imageView.image = UIImage(data: imagesData[x])
            imageView.clipsToBounds = true
            let xPosition = view.frame.width * CGFloat(x)
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: scrollView.frame.width,
                                     height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFill

            scrollView.contentSize.width = scrollView.frame.width * CGFloat(x + 1)
            scrollView.contentSize.height = imageView.frame.height
            scrollView.addSubview(imageView)
        }
    }
    
    // MARK: CopyCoordinatesToClipboard Use case
    @objc private func copyCoordinatesToClipboard() {
        let request = LocationDescription.CopyCoordinatesToClipboard.Request()
        interactor?.copyCoordinatesToClipboard(request: request)
    }
    
    func displayCopiedToClipboardMessage(viewModel: LocationDescription.CopyCoordinatesToClipboard.ViewModel) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.copiedToClipboardMessageBackgroundView.alpha = 1.0
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.copiedToClipboardMessageBackgroundView.alpha = 0
            }
        }
    }
    
    // MARK: OpenLocationInMaps Use case
    @objc private func openLocationInMaps() {
        let alert = UIAlertController(title: "Открыть локацию в приложении Карты?", message: nil, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            let request = LocationDescription.OpenLocationInMaps.Request()
            self?.interactor?.openLocationInMaps(request: request)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: Other methods
    private func tuneUI() {
        view.backgroundColor = .lightTortilla
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.35)
        }
        scrollView.delegate = self
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.35)
        }
        
        view.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(scrollView.snp.bottom)
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
        
        view.addSubview(copiedToClipboardMessageBackgroundView)
        copiedToClipboardMessageBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(70)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.equalTo(60)
        }
        
        copiedToClipboardMessageBackgroundView.addSubview(copiedToClipboardMessage)
        copiedToClipboardMessage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func configure() {
        let viewController = self
        let interactor = LocationDescriptionInteractor(worker: LocationDescriptionWorker())
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

    // MARK: - UIScrollViewDelegate
extension LocationDescriptionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
}
