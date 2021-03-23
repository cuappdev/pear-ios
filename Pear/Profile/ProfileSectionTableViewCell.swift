//
//  ProfileSectionTableViewCell.swift
//  Pear
//
//  Created by Lucy Xu on 3/13/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileSectionTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let itemsCollectionView = SelfSizingCollectionView()
    private let titleLabel = UILabel()

    static let reuseIdentifier = "ProfileSectionTableViewCell"
    private var sectionType: ProfileSectionType? = nil
    private var items: [String] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        titleLabel.font = ._12CircularStdMedium
        titleLabel.textColor = .greenGray
        contentView.addSubview(titleLabel)

        itemsCollectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        itemsCollectionView.backgroundColor = .clear
        itemsCollectionView.register(
            ProfilePillCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfilePillCollectionViewCell.reuseIdentifier
        )
        itemsCollectionView.layoutIfNeeded()
        contentView.addSubview(itemsCollectionView)

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().offset(20)
            make.height.equalTo(15)
        }

        itemsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    func configure(for user: User, type: ProfileSectionType) {
        titleLabel.text = type.getTitle(for: user)
        sectionType = type
        switch type {
        case .groups:
            items = user.groups
        case .interests:
            items = user.interests
        default:
            break
        }
        itemsCollectionView.reloadData()
        itemsCollectionView.sizeToFit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProfileSectionTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = sectionType,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePillCollectionViewCell.reuseIdentifier, for: indexPath) as?
                 ProfilePillCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: items[indexPath.item], type: sectionType)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

}

extension ProfileSectionTableViewCell: UICollectionViewDelegateFlowLayout {

    func calculateNecessaryWidth(text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = ._16CircularStdBook
        label.sizeToFit()
        return label.frame.width
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: calculateNecessaryWidth(text: items[indexPath.item]) + 52, height: 32)
    }

}
