//
//  FilterCell.swift
//  SearchRestaurant
//
//  Created by 강석호 on 6/19/24.
//

import UIKit
import SnapKit

class FilterCell: UICollectionViewCell {
    static let identifier = "FilterCell"
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: String) {
        label.text = category
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.backgroundColor = .gray
                label.textColor = .white
            } else {
                label.backgroundColor = .white
                label.textColor = .black
            }
        }
    }
}
