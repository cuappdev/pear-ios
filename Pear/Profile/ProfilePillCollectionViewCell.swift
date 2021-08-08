//
//  ProfilePillCollectionViewCell.swift
//  Pear
//
//  Created by Lucy Xu on 3/13/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class ProfilePillCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let label = UILabel()
    private let imageView = UIImageView()

    static let reuseIdentifier = "ProfilePillCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 18
        backgroundColor = .paleGreen

        label.textAlignment = .left
        label.font = ._16CircularStdBook
        label.preferredMaxLayoutWidth = 120
        label.numberOfLines = 0
        label.textColor = .black
        contentView.addSubview(label)

        contentView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalTo(label)
            make.leading.equalToSuperview().inset(12)
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(6)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
        }
    }

    func configure(with item: Topic, type: ProfileSectionType) {
        label.text = item.name
        if let topicPictureUrl = URL(string: item.imgUrl) {
            self.imageView.kf.setImage(with: topicPictureUrl)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

