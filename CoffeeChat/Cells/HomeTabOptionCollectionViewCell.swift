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
    private var activeCellColor: UIColor = .darkGreen
    private var inactiveCellColor: UIColor = .inactiveGreen

    override var isSelected: Bool {
        didSet {
            tabLabel.textColor = isSelected ? activeCellColor : inactiveCellColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        tabLabel.textColor = inactiveCellColor
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
