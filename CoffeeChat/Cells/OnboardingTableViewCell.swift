//
//  OnboardingTableViewCell.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/3/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class OnboardingTableViewCell: UITableViewCell {

    enum LastShownItem {
        case interest, group, nothing
    }

    // MARK: Private View Vars
    private let backdropView = UIView()
    private let interestImageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoriesLabel = UILabel()

    override var isSelected: Bool {
        didSet {
            if shouldSelectionChangeAppearence {
                changeColor(selected: isSelected)
            }
        }
    }

    private var lastShownItem: LastShownItem = .nothing

    // Whether the cell should change its appearence when selected
    var shouldSelectionChangeAppearence = true

    static let reuseIdentifier = "OnboardingTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        backdropView.layer.cornerRadius = 8
        backdropView.layer.masksToBounds = true

        interestImageView.layer.cornerRadius = 4
        backdropView.addSubview(interestImageView)

        titleLabel.textColor = .black
        titleLabel.font = ._16CircularStdBook
        backdropView.addSubview(titleLabel)

        backdropView.clipsToBounds = false
        backdropView.layer.shadowColor = UIColor.black.cgColor
        backdropView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backdropView.layer.shadowOpacity = 0.1
        backdropView.layer.shadowRadius = 2
        contentView.addSubview(backdropView)

        categoriesLabel.textColor = .greenGray
        categoriesLabel.font = ._12CircularStdBook
        contentView.addSubview(categoriesLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let imageSize = CGSize(width: 22, height: 22)
        let sidePadding: CGFloat = 12

        backdropView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview()
        }

        interestImageView.snp.remakeConstraints { make in
            make.size.equalTo(imageSize)
            make.leading.equalToSuperview().inset(sidePadding)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(interestImageView.snp.trailing).offset(8)
            if categoriesLabel.text != nil {
                make.top.equalToSuperview().inset(8.5)
            } else {
                make.centerY.equalToSuperview()
            }
        }

        categoriesLabel.isHidden = categoriesLabel.text == nil
        categoriesLabel.snp.remakeConstraints { make in
             make.leading.equalTo(titleLabel)
             make.top.equalTo(titleLabel.snp.bottom)
        }
    }

    func configure(with interest: Interest) {
        titleLabel.text = interest.name
        categoriesLabel.text = interest.categories?.joined(separator: ", ") ?? ""
        print("set categories to \(categoriesLabel.text)")
        if let pictureString = interest.imageURL {
            interestImageView.kf.setImage(with: URL(string: pictureString))
        } else {
            interestImageView.image = nil
        }

        if lastShownItem != .interest {
            lastShownItem = .interest
            setupConstraints()
        }
    }

    func configure(with group: Group) {
        titleLabel.text = group.name
        categoriesLabel.text = nil
        if let pictureString = group.imageURL {
            interestImageView.kf.setImage(with: URL(string: pictureString))
        } else {
            interestImageView.image = nil
        }

        if lastShownItem != .group {
            lastShownItem = .group
            setupConstraints()
        }
    }

    func changeColor(selected: Bool) {
        backdropView.backgroundColor = selected ? .pearGreen : .white
    }

}
