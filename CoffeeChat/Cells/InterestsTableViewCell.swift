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
    private let cellBackground = UIView()
    private let interestImage = UIImageView()
    private let titleLabel = UILabel()
    private let categoriesLabel = UILabel()

    static let reuseIdentifier = "InterestsTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none

        cellBackground.backgroundColor = .backgroundLightGray
        cellBackground.layer.cornerRadius = 8
        contentView.addSubview(cellBackground)

        interestImage.backgroundColor = .backgroundDarkGray
        interestImage.layer.cornerRadius = 4
        cellBackground.addSubview(interestImage)

        titleLabel.textColor = .textBlack
        titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
        cellBackground.addSubview(titleLabel)

        categoriesLabel.textColor = .textLightGray
        categoriesLabel.font = .systemFont(ofSize: 12, weight: .regular)
        cellBackground.addSubview(categoriesLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let imageSize = CGSize(width: 32, height: 32)
        let sidePadding: CGFloat = 12
        let textSidePadding: CGFloat = 8

        cellBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        interestImage.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
            make.leading.equalToSuperview().inset(sidePadding)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(interestImage.snp.trailing).offset(textSidePadding)
            make.top.equalTo(cellBackground).inset(sidePadding)
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
        cellBackground.backgroundColor = selected ? .backgroundRed : .backgroundLightGray
    }

}
