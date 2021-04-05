//
//  ProfilePromptTableViewCell.swift
//  Pear
//
//  Created by Lucy Xu on 3/13/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class ProfilePromptTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let descriptionTextView = UITextView()
    private let titleLabel = UILabel()

    static let reuseIdentifier = "ProfilePromptTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        titleLabel.font = ._12CircularStdMedium
        titleLabel.textColor = .greenGray
        contentView.addSubview(titleLabel)

        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        descriptionTextView.layer.backgroundColor = UIColor.paleGreen.cgColor
        descriptionTextView.font = ._14CircularStdBook
        descriptionTextView.textColor = .black
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.layer.cornerRadius = 16
        descriptionTextView.sizeToFit()
        contentView.addSubview(descriptionTextView)

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(15)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    func configure(for user: User, type: ProfileSectionType) {
        titleLabel.text = type.getTitle(for: user)
        if type == .basics {
            descriptionTextView.attributedText =
                NSMutableAttributedString()
                .thinFont("I study ")
                .normalFont(user.major)
                .thinFont(" in the class of ")
                .normalFont(user.graduationYear ?? "")
                .thinFont(", and my home is in ")
                .normalFont(user.hometown ?? "")
                .thinFont("! My pronouns are ")
                .normalFont((user.pronouns ?? "").lowercased())
                .thinFont(".")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

