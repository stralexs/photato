//
//  LocationsListTableViewCell.swift
//  Photato
//
//  Created by Alexander Sivko on 6.08.23.
//

import UIKit
import SnapKit

final class LocationTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "LocationTableViewCell"
    
    private let background: UIView = {
        let background = UIView()
        background.backgroundColor = .systemGray5
        background.layer.cornerRadius = 5
        
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 0.3
        background.layer.shadowOffset = CGSize(width: 5, height: 5)
        background.layer.shadowRadius = 5
        
        return background
    }()
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        return verticalStackView
    }()
    
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let locationAddressHorizontalStackView: UIStackView = {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        return horizontalStackView
    }()
    
    private let locationAddressImageViewContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let locationAddressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "location.circle")
        imageView.tintColor = .tortilla
        return imageView
    }()
    
    private let locationAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let locationCoordinatesHorizontalStackView: UIStackView = {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        return horizontalStackView
    }()
    
    private let locationCoordinatesImageViewContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let locationCoordinatesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "mappin.circle")
        imageView.tintColor = .tortilla
        return imageView
    }()
    
    private let locationCoordinatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tuneUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with location: Location) {
        guard let firstImageData = location.imagesData.first else { return }
        let longitude = round(100_000 * location.coordinates.longitude) / 100_000
        let latitude = round(100_000 * location.coordinates.latitude) / 100_000
        
        locationNameLabel.text = location.name
        leftImageView.image = UIImage(data: firstImageData)
        locationAddressLabel.text = location.address
        locationCoordinatesLabel.text = "\(latitude), \(longitude)"
    }
    
    private func tuneUI() {
        contentView.addSubview(background)
        background.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
        
        background.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
            make.left.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
        }
        
        background.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.left.equalTo(leftImageView).inset(100)
            make.top.bottom.right.equalToSuperview().inset(10)
        }
        
        verticalStackView.addArrangedSubview(locationNameLabel)
        
        locationNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.34)
        }
        
        verticalStackView.addArrangedSubview(locationAddressHorizontalStackView)
        
        locationAddressHorizontalStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        locationAddressHorizontalStackView.addArrangedSubview(locationAddressImageViewContainerView)
        locationAddressHorizontalStackView.addArrangedSubview(locationAddressLabel)
        
        locationAddressImageViewContainerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.13)
        }
        
        locationAddressImageViewContainerView.addSubview(locationAddressImageView)
        locationAddressImageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        locationAddressLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.87)
        }
        
        verticalStackView.addArrangedSubview(locationCoordinatesHorizontalStackView)
        
        locationAddressHorizontalStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        locationCoordinatesHorizontalStackView.addArrangedSubview(locationCoordinatesImageViewContainerView)
        locationCoordinatesHorizontalStackView.addArrangedSubview(locationCoordinatesLabel)
        
        locationCoordinatesImageViewContainerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.13)
        }
        
        locationCoordinatesImageViewContainerView.addSubview(locationCoordinatesImageView)
        locationCoordinatesImageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        locationCoordinatesLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.87)
        }
    }
}
