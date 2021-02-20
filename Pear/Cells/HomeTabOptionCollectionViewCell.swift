//
//  HomeTabOptionCollectionViewCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class HomeTabOptionCollectionViewCell: UICollectionViewCell {

    private let tabLabel = UILabel()
    static let reuseIdentifier = "HomeTabOptionCollectionViewCell"

    override var isSelected: Bool {
        didSet {
            tabLabel.textColor = isSelected ? .darkGreen : .inactiveGreen
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        tabLabel.textColor = .inactiveGreen
        tabLabel.font = ._16CircularStdBook
        addSubview(tabLabel)

        tabLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tabText: String) {
        tabLabel.text = tabText
    }
}
