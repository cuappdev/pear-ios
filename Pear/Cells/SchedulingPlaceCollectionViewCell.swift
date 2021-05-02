//
//  SchedulingPlaceCollectionViewCell.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 3/4/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class SchedulingPlaceCollectionViewCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    static let campusReuseId = "campusReuseIdentifier"
    static let ctownReuseId = "ctownReuseIdentiifier"
    static let onlineReuseId = "onlineReuseIdentifier"

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .pearGreen : .backgroundWhite
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = false

        contentView.backgroundColor = .backgroundWhite
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        contentView.layer.shadowOpacity = 0.15
        contentView.layer.shadowRadius = 2

        titleLabel.text = ""
        titleLabel.textColor = .black
        titleLabel.font = ._16CircularStdBook
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, isPicking: Bool) {
        titleLabel.text = title
        titleLabel.textAlignment = isPicking ? .center : .left
    }

}
