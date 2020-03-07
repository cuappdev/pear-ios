//
//  DayCollectionViewCell.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/24/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    private let dayBackgroundView = UIView()
    private let dayLabel = UILabel()
    private let indicatorView = UIView()

    private let backgroundViewSize = CGSize(width: 36, height: 36)
    private let indicatorViewSize = CGSize(width: 8, height: 8)

    override var isSelected: Bool {
        didSet {
            indicatorView.isHidden = !isSelected
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        dayBackgroundView.backgroundColor = .backgroundLightGrayGreen
        dayBackgroundView.layer.cornerRadius = backgroundViewSize.width/2
        contentView.addSubview(dayBackgroundView)

        dayLabel.textColor = .textBlack
        dayLabel.font = ._16CircularStdBook
        contentView.addSubview(dayLabel)

        indicatorView.backgroundColor = .pearGreen
        indicatorView.layer.cornerRadius = indicatorViewSize.width/2
        indicatorView.isHidden = true
        contentView.addSubview(indicatorView)

        setupConstraints()
    }

    private func setupConstraints() {
        dayBackgroundView.snp.makeConstraints { make in
            make.size.equalTo(backgroundViewSize)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        dayLabel.snp.makeConstraints { make in
            make.center.equalTo(dayBackgroundView)
        }

        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(dayBackgroundView.snp.bottom).offset(4)
            make.size.equalTo(indicatorViewSize)
            make.centerX.equalToSuperview()
        }
    }

    func configure(for day: String) {
        dayLabel.text = day
    }

    func updateBackgroundColor(isAvailable: Bool) {
        dayBackgroundView.backgroundColor = isAvailable ? .pearGreen : .backgroundLightGrayGreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
