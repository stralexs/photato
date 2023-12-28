//
//  HourlyForecastCollectionViewCell.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import UIKit

final class HourlyForecastCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "HourlyForecastCollectionViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkOliveGreen
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let weatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkOliveGreen
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkOliveGreen
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        tuneConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with weatherParameters: Weather.Hourly, and index: Int) {
        if index == 0 {
            timeLabel.text = "Now"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            formatter.timeZone = TimeZone(identifier: "Europe/Minsk")
            let formattedHour = formatter.string(from: Date(timeIntervalSince1970: weatherParameters.dt))
            timeLabel.text = formattedHour
        }
        temperatureLabel.text = "\(Int(round(weatherParameters.temp)))°"
        weatherConditionImageView.image = UIImage(named: "\(weatherParameters.weather.first!.icon)")
    }
    
    private func tuneConstraints() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.right.bottom.equalToSuperview()
        }
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(weatherConditionImageView)
        stackView.addArrangedSubview(temperatureLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.34)
        }
        
        weatherConditionImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.33)
        }
    }
}
