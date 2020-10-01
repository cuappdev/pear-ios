//
//  SimpleOnboardingTableViewCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 9/16/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class SimpleOnboardingTableViewCell: UITableViewCell {

    // MARK: Private View Vars
    private let backdropView = UIView()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()

    // MARK: Private Data Vars
    private var isInterest: Bool = false
    static let reuseIdentifier = "SimpleOnboardingTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = .backgroundLightGreen

        backdropView.backgroundColor = .clear
        backdropView.clipsToBounds = false
        backdropView.layer.shadowColor = UIColor.black.cgColor
        backdropView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backdropView.layer.shadowOpacity = 0.1
        backdropView.layer.shadowRadius = 2
        backdropView.layer.cornerRadius = 8
        backdropView.layer.masksToBounds = true
        contentView.addSubview(backdropView)

        titleLabel.textColor = .black
        titleLabel.font = ._16CircularStdBook
        backdropView.addSubview(titleLabel)

        subtitleLabel.textColor = .greenGray
        subtitleLabel.font = ._12CircularStdBook
        backdropView.addSubview(subtitleLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        backdropView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
        }

    }

    func configure(with text: String, type: InterestGroupEnum, subtitle: String?) {
        titleLabel.text = text
        isInterest = type == .interest
        subtitleLabel.isHidden = type != .interest
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            if isInterest {
                make.top.equalToSuperview().offset(8)
            } else {
                make.centerY.equalToSuperview()
            }
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backdropView.backgroundColor = selected ? .pearGreen : .white
    }

}

