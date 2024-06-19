//
//  RestaurantListTableViewCell.swift
//  SearchRestaurant
//
//  Created by 강석호 on 6/19/24.
//

import UIKit
import SnapKit
import Kingfisher

class RestaurantListTableViewCell: UITableViewCell {
    
    let restaurantImageView = UIImageView()
    let nameLabel = UILabel()
    let phoneNumberLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        restaurantImageView.contentMode = .scaleToFill
        restaurantImageView.clipsToBounds = true
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 14)
        phoneNumberLabel.textColor = .gray
        
        contentView.addSubview(restaurantImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneNumberLabel)
        
        restaurantImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(restaurantImageView.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(restaurantImageView.snp.trailing).offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with restaurant: Restaurant) {
        if let url = URL(string: restaurant.image) {
            restaurantImageView.kf.setImage(with: url)
        }
        nameLabel.text = restaurant.name
        phoneNumberLabel.text = restaurant.phoneNumber
    }
}
