//
//  WeatherForecastViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import UIKit

protocol WeatherForecastDisplayLogic: AnyObject {
    func displayLocationName(viewModel: WeatherForecast.GetLocationName.ViewModel)
    func displayWeather(viewModel: WeatherForecast.GetWeather.ViewModel)
}

class WeatherForecastViewController: UIViewController, WeatherForecastDisplayLogic {
    // MARK: - Properties
    var interactor: WeatherForecastBusinessLogic?
    var router: (NSObjectProtocol & WeatherForecastDataPassing)?
    
    private var hourlyWeather = [HourlyWeatherParameters]()
    private var dailyWeather = [DailyWeatherParameters]()
    
    private let rootVerticalStackView: UIStackView = {
        let rootVerticalStackView = UIStackView()
        rootVerticalStackView.axis = .vertical
        return rootVerticalStackView
    }()
    
    private let locationWeatherContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let swipeDownSignView: UIView = {
        let swipeDownSignView = UIView()
        swipeDownSignView.backgroundColor = .lightTortilla
        return swipeDownSignView
    }()
    
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 35, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let locationWeatherHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let temperatureAndStatusContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 90, weight: .thin)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .light)
        return label
    }()
    
    private let humidityAndWindSpeedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let humidityContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let humidityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "humidity")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .light)
        return label
    }()
    
    private let windSpeedContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let windSpeedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "wind")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .light)
        return label
    }()
    
    private let collectionViewContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let hourlyWeatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 60, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HourlyForecastCollectionViewCell.self, forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightTortilla
        return collectionView
    }()
    
    private let tableViewContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let dailyWeatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
        tableView.rowHeight = 70
        return tableView
    }()
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationName()
        getWeather()
        tuneUI()
    }
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - Methods
    
    // MARK: GetLocationName Use case
    private func getLocationName() {
        let request = WeatherForecast.GetLocationName.Request()
        interactor?.getLocationName(request: request)
    }
    
    func displayLocationName(viewModel: WeatherForecast.GetLocationName.ViewModel) {
        locationNameLabel.text = viewModel.locationName
    }
    
    // MARK: GetWeather Use case
    private func getWeather() {
        let request = WeatherForecast.GetWeather.Request()
        interactor?.getWeather(request: request)
    }
    
    func displayWeather(viewModel: WeatherForecast.GetWeather.ViewModel) {
        if viewModel.errorDescription != nil {
            guard let errorDescription = viewModel.errorDescription else { return }
            let alert = UIAlertController(title: "\(errorDescription)", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let currentWeather = viewModel.currentWeatherDetails,
                      let hourlyForecast = viewModel.hourlyForecast,
                      let dailyForecast = viewModel.dailyForecast else { return }
                
                self?.temperatureLabel.text = currentWeather.temperature
                self?.statusLabel.text = currentWeather.mainStatus
                self?.humidityLabel.text = currentWeather.humidity
                self?.windSpeedLabel.text = currentWeather.windSpeed
                
                self?.hourlyWeather = hourlyForecast
                self?.dailyWeather = dailyForecast
                self?.hourlyWeatherCollectionView.reloadData()
                self?.dailyWeatherTableView.reloadData()
            }
        }
    }
    
    // MARK: Other methods
    private func tuneUI() {
        view.backgroundColor = .tortilla
        
        view.addSubview(rootVerticalStackView)
        rootVerticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rootVerticalStackView.addArrangedSubview(locationWeatherContainerView)
        rootVerticalStackView.addArrangedSubview(collectionViewContainerView)
        rootVerticalStackView.addArrangedSubview(tableViewContainerView)
        
        locationWeatherContainerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        
        locationWeatherContainerView.addSubview(swipeDownSignView)
        swipeDownSignView.snp.makeConstraints { make in
            make.height.equalTo(7)
            make.width.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(7)
        }
        swipeDownSignView.layer.cornerRadius = 3
        
        locationWeatherContainerView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(swipeDownSignView.snp.bottom).offset(7)
            make.left.right.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.20)
        }
        
        locationWeatherContainerView.addSubview(locationWeatherHorizontalStackView)
        locationWeatherHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(locationNameLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        locationWeatherHorizontalStackView.addArrangedSubview(temperatureAndStatusContainerView)
        locationWeatherHorizontalStackView.addArrangedSubview(humidityAndWindSpeedStackView)
        
        temperatureAndStatusContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.50)
        }
        
        temperatureAndStatusContainerView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        temperatureAndStatusContainerView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        
        humidityAndWindSpeedStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.50)
        }
        humidityAndWindSpeedStackView.addArrangedSubview(humidityContainerView)
        humidityAndWindSpeedStackView.addArrangedSubview(windSpeedContainerView)
        
        humidityContainerView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.50)
        }
        
        humidityContainerView.addSubview(humidityImageView)
        humidityImageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        humidityContainerView.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(humidityImageView.snp.right).offset(10)
        }
        
        windSpeedContainerView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.50)
        }
        
        windSpeedContainerView.addSubview(windSpeedImageView)
        windSpeedImageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        windSpeedContainerView.addSubview(windSpeedLabel)
        windSpeedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(windSpeedImageView.snp.right).offset(10)
        }
        
        collectionViewContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        tableViewContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.50)
        }
        
        collectionViewContainerView.addSubview(hourlyWeatherCollectionView)
        hourlyWeatherCollectionView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(15)
            make.right.bottom.equalToSuperview().inset(15)
        }
        hourlyWeatherCollectionView.layer.cornerRadius = 15
        hourlyWeatherCollectionView.dataSource = self
        
        tableViewContainerView.addSubview(dailyWeatherTableView)
        dailyWeatherTableView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(15)
            make.right.bottom.equalToSuperview().inset(15)
        }
        dailyWeatherTableView.layer.cornerRadius = 15
        dailyWeatherTableView.dataSource = self
        dailyWeatherTableView.backgroundColor = .lightTortilla
    }
    
    private func configure() {
        let viewController = self
        let interactor = WeatherForecastInteractor(weatherManager: WeatherManager())
        let presenter = WeatherForecastPresenter()
        let router = WeatherForecastRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
}

extension WeatherForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier, for: indexPath) as? DailyForecastTableViewCell else { return UITableViewCell() }
        let weatherParameter = dailyWeather[indexPath.row]
        cell.configure(with: weatherParameter, and: indexPath.row)
        return cell
    }
}

extension WeatherForecastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.identifier, for: indexPath) as? HourlyForecastCollectionViewCell else { return UICollectionViewCell() }
        let weatherParameter = hourlyWeather[indexPath.row]
        cell.configure(with: weatherParameter, and: indexPath.row)
        return cell
    }
}
