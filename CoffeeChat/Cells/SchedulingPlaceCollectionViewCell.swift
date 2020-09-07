//
//  SchedulingPlaceCollectionViewCell.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 3/4/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class SchedulingPlaceCollectionViewCell: UICollectionViewCell {

    // MARK: Private view vars
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        self.layer.masksToBounds = false

        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        contentView.layer.shadowOpacity = 0.15
        contentView.layer.shadowRadius = 2
        changeSelection(selected: false)

        titleLabel.text = ""
        titleLabel.textColor = .textBlack
        titleLabel.font = ._16CircularStdBook
        contentView.addSubview(titleLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }

    func configure(with title: String, isPicking: Bool) {
        titleLabel.text = title
        titleLabel.textAlignment = isPicking ? .center : .left
    }

    func changeSelection(selected: Bool) {
        contentView.backgroundColor = selected ? .pearGreen : .backgroundWhite
    }

}
