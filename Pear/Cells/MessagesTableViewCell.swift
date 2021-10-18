//
//  MessagesTableViewCell.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/2/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class MessagesTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let infoImage = UIImageView()
    private let infoLabel = UILabel()
    private let nameLabel = UILabel()
    private let profileImage = UIImageView()
    private let timeLabel = UILabel()

    // MARK: - Private Data Vars
    private let profileImageWidth: CGFloat = 50

    static let reuseId = "messagesReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImageWidth / 2
        contentView.addSubview(profileImage)

        nameLabel.textColor = .black
        nameLabel.font = ._16CircularStdBook
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)

        infoImage.clipsToBounds = true
        infoImage.contentMode = .scaleAspectFit
        infoImage.image = UIImage(named: "currentPear")
        contentView.addSubview(infoImage)

        infoLabel.textColor = .greenGray
        infoLabel.font = ._12CircularStdBook
        infoLabel.text = "Current pear"
        contentView.addSubview(infoLabel)

        timeLabel.textColor = .inactiveGreen
        timeLabel.font = ._12CircularStdBook
        contentView.addSubview(timeLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(profileImageWidth)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(12)
            make.top.equalTo(profileImage).offset(5)
        }

        infoImage.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.width.height.equalTo(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }

        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoImage.snp.trailing).offset(5)
            make.centerY.equalTo(infoImage)
        }

        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(28)
            make.top.equalTo(profileImage)
        }
    }

    func configure(for pair: MatchedUser, status: String, week: Int) {
        profileImage.kf.setImage(with: URL(string: pair.profilePicUrl ?? ""))
        nameLabel.text = "\(pair.firstName) \(pair.lastName)"
        infoImage.isHidden = (status == Constants.Match.canceled || status == Constants.Match.inactive) ? true : false
        infoLabel.isHidden = (status == Constants.Match.canceled || status == Constants.Match.inactive) ? true : false
        timeLabel.text = week == 1 ? "\(week) week ago" : "\(week) weeks ago"
    }

}
