//
//  InterestsTableViewCell.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/3/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class InterestsTableViewCell: UITableViewCell {

    // MARK: Private View Vars
    private let categoriesLabel = UILabel()
    private let cellBackgroundView = UIView()
    private let interestImageView = UIImageView()
    private let titleLabel = UILabel()

    static let reuseIdentifier = "InterestsTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .none

        cellBackgroundView.backgroundColor = .backgroundLightGray
        cellBackgroundView.layer.cornerRadius = 8
        contentView.addSubview(cellBackgroundView)

        interestImageView.backgroundColor = .backgroundDarkGray
        interestImageView.layer.cornerRadius = 4
        cellBackgroundView.addSubview(interestImageView)

        titleLabel.textColor = .textBlack
        titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
        cellBackgroundView.addSubview(titleLabel)

        categoriesLabel.textColor = .textLightGray
        categoriesLabel.font = .systemFont(ofSize: 12, weight: .regular)
        cellBackgroundView.addSubview(categoriesLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let imageSize = CGSize(width: 32, height: 32)
        let sidePadding: CGFloat = 12
        let textSidePadding: CGFloat = 8

        cellBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        interestImageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
            make.leading.equalToSuperview().inset(sidePadding)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(interestImageView.snp.trailing).offset(textSidePadding)
            make.top.equalTo(cellBackgroundView).inset(sidePadding)
        }

        categoriesLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }

    func configure(with interest: Interest) {
        titleLabel.text = interest.name
        categoriesLabel.text = interest.categories
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cellBackgroundView.backgroundColor = selected ? .backgroundRed : .backgroundLightGray
    }

}
