//
//  OnboardingTableViewCell2.swift
//  Pear
//
//  Created by Lucy Xu on 5/15/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class OnboardingTableViewCell2: UITableViewCell {

    private enum LastShownItem {
        case interest, group, none
    }

    // MARK: Private View Vars
    private let backdropView = UIView()
    private let categoriesLabel = UILabel()
    private let interestImageView = UIImageView()
    private let titleLabel = UILabel()

    /// The type of item the cell was last showing. Used to determine if the cell needs to relayout its views for
    /// the new item type.
    private var lastShownItem: LastShownItem = .none
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

        backdropView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview()
        }

        interestImageView.snp.remakeConstraints { make in
            make.size.equalTo(imageSize)
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(interestImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
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

    func configure(with interest: InterestV2) {
        titleLabel.text = interest.name
        categoriesLabel.text = interest.subtitle
        if let interestImageUrl = URL(string: interest.imgUrl) {
            interestImageView.kf.setImage(with: interestImageUrl)
        }

        if lastShownItem != .interest {
            lastShownItem = .interest
            setupConstraints()
        }
    }

    func configure(with group: GroupV2) {
        titleLabel.text = group.name
        categoriesLabel.text = nil
        if let groupImageUrl = URL(string: group.imgUrl) {
            interestImageView.kf.setImage(with: groupImageUrl)
        }

        if lastShownItem != .group {
            lastShownItem = .group
            setupConstraints()
        }
    }

    func configure(with talkingPoint: TalkingPointV2) {
        titleLabel.text = talkingPoint.name
        categoriesLabel.text = talkingPoint.subtitle
        if let talkingPointImageUrl = URL(string: talkingPoint.imgUrl) {
            interestImageView.kf.setImage(with: talkingPointImageUrl)
        }

        // TODO: Lucy double check what this does...
        if lastShownItem != .group {
            lastShownItem = .group
            setupConstraints()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if shouldSelectionChangeAppearence {
            changeColor(selected: selected)
        }
        super.setSelected(selected, animated: animated)

    }

    func changeColor(selected: Bool) {
        backdropView.backgroundColor = selected ? .pearGreen : .white
    }

}
