//
//  MessagesTableViewCell.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/2/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit
import Kingfisher

class MessagesTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let infoImage = UIImageView()
    private let infoLabel = UILabel()
    private let nameLabel = UILabel()
    private let profileImage = UIImageView()
    private let timeLabel = UILabel()

    // MARK: - Priavte Data Vars
    private let profileImageWidth: CGFloat = 50
    private let statusData: [String: [String]] = [
        "active": ["Current pear", "currentPear"],
        "canceled": ["Cancelled", "cancelled"]
    ]
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
        infoImage.contentMode = .scaleAspectFill
        contentView.addSubview(infoImage)

        infoLabel.textColor = .greenGray
        infoLabel.font = ._12CircularStdBook
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

    func configure(for messageUser: MessageUser) {
        profileImage.kf.setImage(with: URL(string: messageUser.profilePictureURL))
        nameLabel.text = "\(messageUser.firstName) \(messageUser.lastName)"
        print(messageUser.status)
        if let imageName = statusData[messageUser.status]?[1], let status = statusData[messageUser.status]?[0] {
            infoImage.image = UIImage(named: imageName)
            print(imageName)
            infoLabel.text = status
        }
        timeLabel.text = "TODO - add timestamp"
    }

}
