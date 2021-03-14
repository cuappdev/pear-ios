//
//  CommunityUserTableViewCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/14/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class CommunityUserTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let informationLabel = UILabel()
    private let interestsCollectionView = SelfSizingCollectionView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()

    // MARK: - Private Data Vars
    private var interests: [String] = []
    static let reuseIdentifier = "CommunityUserTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.clipsToBounds = false
        contentView.addSubview(containerView)

        profileImageView.layer.cornerRadius = 18
        profileImageView.layer.backgroundColor = UIColor.gray.cgColor
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        containerView.addSubview(profileImageView)

        nameLabel.font = ._16CircularStdBook
        nameLabel.textColor = .black
        containerView.addSubview(nameLabel)

        informationLabel.font = ._10CircularStdBook
        informationLabel.textColor = .greenGray
        containerView.addSubview(informationLabel)

        interestsCollectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        interestsCollectionView.dataSource = self
        interestsCollectionView.delegate = self
        interestsCollectionView.backgroundColor = .clear
        interestsCollectionView.register(
            InterestTagCollectionViewCell.self,
            forCellWithReuseIdentifier: InterestTagCollectionViewCell.reuseIdentifier
        )
        interestsCollectionView.layoutIfNeeded()
        containerView.addSubview(interestsCollectionView)

        setupConstraints()
    }

    private func setupConstraints() {
        let bottomPadding: CGFloat = 8
        let topPadding: CGFloat = 12

        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView).inset(bottomPadding)
            make.top.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.leading.top.equalTo(containerView).offset(topPadding)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(topPadding)
            make.trailing.equalTo(containerView).inset(topPadding)
            make.height.equalTo(20)
        }

        informationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(13)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }

        interestsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(informationLabel.snp.bottom).offset(bottomPadding)
            make.bottom.equalTo(containerView).inset(topPadding)
        }
    }

    func configure(with user: CommunityUser) {
        if let firstName = user.firstName, let lastName = user.lastName {
            nameLabel.text = "\(firstName) \(lastName)"
            if let major = user.major, let gradYear = user.graduationYear, let hometown = user.hometown, let pronouns = user.pronouns, let userInterests = user.interests {
                informationLabel.text = "\(major) · \(gradYear) · \(hometown) · \(pronouns)"
                interests = userInterests
                interestsCollectionView.reloadData()
            }

             if let profilePictureURL = user.profilePictureURL {
                 profileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePictureURL, cacheKey: user.netID))
             }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        profileImageView.image = nil
    }

}

extension CommunityUserTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interests.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestTagCollectionViewCell.reuseIdentifier, for: indexPath) as?
                InterestTagCollectionViewCell else { return UICollectionViewCell() }
        let interest = interests[indexPath.row]
        cell.configure(with: interest)
        return cell
    }

}

extension CommunityUserTableViewCell: UICollectionViewDelegateFlowLayout {

    func calculateNecessaryWidth(text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = ._12CircularStdBook
        label.sizeToFit()
        return label.frame.width
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalPadding: CGFloat = 16
        return CGSize(width: calculateNecessaryWidth(text: interests[indexPath.item]) + totalHorizontalPadding, height: 19)
    }

}
