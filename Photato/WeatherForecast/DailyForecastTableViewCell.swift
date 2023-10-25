//
//  DailyForecastTableViewCell.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import UIKit

final class DailyForecastTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "DailyForecastTableViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let weekdayContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkOliveGreen
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let weatherConditionContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let weatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkOliveGreen
        return imageView
    }()
    
    private let nightTemperatureContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let nightTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkOliveGreen
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let dayTemperatureContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let dayTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkOliveGreen
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tuneConstraints()
        tuneUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with weatherParameters: DailyWeatherParameters, and index: Int) {
        if index == 0 {
            weekdayLabel.text = "Today"
        } else {
            weekdayLabel.text = weatherParameters.weekday
        }
        nightTemperatureLabel.text = "Night: \(Int(round(weatherParameters.tempNight)))°"
        dayTemperatureLabel.text = "Day: \(Int(round(weatherParameters.tempDay)))°"
        weatherConditionImageView.image = UIImage(named: "\(weatherParameters.icon)")
    }
    
    private func tuneConstraints() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().inset(10)
        }
        stackView.addArrangedSubview(weekdayContainerView)
        stackView.addArrangedSubview(weatherConditionContainerView)
        stackView.addArrangedSubview(nightTemperatureContainerView)
        stackView.addArrangedSubview(dayTemperatureContainerView)
        
        weekdayContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.27)
        }
        
        weekdayContainerView.addSubview(weekdayLabel)
        weekdayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        weatherConditionContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.20)
        }
        
        weatherConditionContainerView.addSubview(weatherConditionImageView)
        weatherConditionImageView.snp.makeConstraints { make in
            make.height.width.centerX.centerY.equalToSuperview()
        }
        
        nightTemperatureContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.28)
        }
        
        nightTemperatureContainerView.addSubview(nightTemperatureLabel)
        nightTemperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
        }
        
        dayTemperatureContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        dayTemperatureContainerView.addSubview(dayTemperatureLabel)
        dayTemperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
        }
    }
    
    private func tuneUI() {
        contentView.backgroundColor = .lightTortilla
    }
}
