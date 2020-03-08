//
//  SchedulingCollectionViewCell.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 3/4/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class SchedulingCollectionViewCell: UICollectionViewCell {

    // MARK: Private view vars
    private let titleLabel = UILabel()
    private let backView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        self.layer.masksToBounds = false

        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = false
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backView.layer.shadowOpacity = 0.15
        backView.layer.shadowRadius = 2
        changeSelection(selected: false)
        contentView.addSubview(backView)

        titleLabel.text = ""
        titleLabel.textColor = .textBlack
        titleLabel.font = UIFont._16CircularStdBook
        backView.addSubview(titleLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
    }

    func configure(with title: String) {
        titleLabel.text = title
    }

    func changeSelection(selected: Bool) {
        backView.backgroundColor = selected ? .pearGreen : .backgroundWhite
    }

}
