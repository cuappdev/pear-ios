//
//  ProfileSummaryTableViewCell.swift
//  Pear
//
//  Created by Lucy Xu on 3/11/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class ProfileSummaryTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let nameLabel = UILabel()
    private let netIdLabel = UILabel()
    private let profileImageView = UIImageView()

    private let profileImageSize = CGSize(width: 150, height: 150)

    static let reuseIdentifier = "ProfileSummaryTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        profileImageView.backgroundColor = .greenGray
        profileImageView.layer.cornerRadius = profileImageSize.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        contentView.addSubview(profileImageView)

        nameLabel.font = ._24CircularStdMedium
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)

        netIdLabel.font = ._14CircularStdBook
        netIdLabel.textColor = .greenGray
        netIdLabel.textAlignment = .center
        contentView.addSubview(netIdLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(profileImageSize)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }

        netIdLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    func configure(for user: User) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        netIdLabel.text = "Reach me at \(user.netID)"
        if let profilePictureURL = URL(string: user.profilePictureURL ?? "") {
            profileImageView.kf.setImage(with: profilePictureURL)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
