//
//  CommunityUserTableViewCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/14/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class CommunityUserTableViewCell: UITableViewCell {

    private let containerView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let informationLabel = UILabel()
    private var interestsCollectionView: SelfSizingCollectionView!
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
        containerView.sizeToFit()
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

        let tagsCollectionViewLayout = LeftAlignedFlowLayout()
        interestsCollectionView = SelfSizingCollectionView(
            frame: CGRect(x: 0, y: 0, width: frame.width, height: 0),
            collectionViewLayout: tagsCollectionViewLayout)
        interestsCollectionView.backgroundColor = .clear
        interestsCollectionView.register(InterestTagCollectionViewCell.self, forCellWithReuseIdentifier: InterestTagCollectionViewCell.reuseIdentifier)
        interestsCollectionView.dataSource = self
        interestsCollectionView.delegate = self
        interestsCollectionView.layoutIfNeeded()
        containerView.addSubview(interestsCollectionView)

        setupConstraints()
    }

    private func setupConstraints() {

        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(120)
            make.bottom.equalTo(contentView).inset(8)
        }

        profileImageView.snp.makeConstraints { make in
            make.leading.top.equalTo(containerView).offset(12)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalTo(containerView).inset(12)
            make.height.equalTo(20)
        }

        informationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(13)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }

        interestsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(informationLabel.snp.bottom).offset(8)
            make.bottom.equalTo(containerView).inset(12)
        }

    }

    func configure(with user: User) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        informationLabel.text = "\(user.major) · \(user.graduationYear) · \(user.hometown) · \(user.pronouns)"
        interests = user.interests
        interestsCollectionView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CommunityUserTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
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
        label.font = .systemFont(ofSize: 12)
        label.sizeToFit()
        return label.frame.width
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalPadding: CGFloat = 16
        return CGSize(width: calculateNecessaryWidth(text: interests[indexPath.item]) + totalHorizontalPadding, height: 19)
    }
}
