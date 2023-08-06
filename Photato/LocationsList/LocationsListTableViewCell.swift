//
//  LocationsListTableViewCell.swift
//  Photato
//
//  Created by Alexander Sivko on 6.08.23.
//

import UIKit
import SnapKit

class LocationsListTableViewCell: UITableViewCell {
    static let identifier = "LocationsListTableViewCell"
    
    let background: UIView = {
        let background = UIView()
        background.backgroundColor = .systemGray5
        background.layer.cornerRadius = 5
        
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 0.3
        background.layer.shadowOffset = CGSize(width: 5, height: 5)
        background.layer.shadowRadius = 5
        background.layer.shouldRasterize = true
        
        return background
    }()
    
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "BotanicalGarden1")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let locationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Наименование локации"
        return label
    }()
    
    let locationAddressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "location.circle")
        imageView.tintColor = .tortilla
        return imageView
    }()
    
    let locationAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.text = "ул. Такая-то, 10"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        tuneUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tuneUI() {
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
        
        background.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.left.equalTo(leftImageView).inset(105)
            make.top.equalToSuperview().inset(15)
        }
        
        background.addSubview(locationAddressImageView)
        locationAddressImageView.snp.makeConstraints { make in
            make.left.equalTo(leftImageView).inset(105)
            make.top.equalTo(locationNameLabel).inset(25)
            make.height.width.equalTo(25)
        }
        
        background.addSubview(locationAddressLabel)
        locationAddressLabel.snp.makeConstraints { make in
            make.left.equalTo(locationAddressImageView).inset(30)
            make.top.equalTo(locationNameLabel).inset(25)
        }
    }
}
