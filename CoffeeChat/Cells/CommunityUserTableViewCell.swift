//
//  CommunityUserTableViewCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/14/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class CommunityUserTableViewCell: UITableViewCell {

    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let informationLabel = UILabel()
    private let interestsCollectionView = UICollectionView(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        profileImageView.layer.cornerRadius = 18
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        addSubview(profileImageView)

        nameLabel.font = ._16CircularStdBook
        nameLabel.textColor = .black
        addSubview(nameLabel)

        informationLabel.font = ._10CircularStdBook
        informationLabel.textColor = .greenGray
        addSubview(informationLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(20)
        }

        informationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(13)
        }


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
