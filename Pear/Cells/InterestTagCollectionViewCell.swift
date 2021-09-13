//
//  InterestTagCollectionViewCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/18/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class InterestTagCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let interestTagLabel = UILabel()

    static let reuseIdentifier = "InterestTagCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        layer.cornerRadius = 11
        backgroundColor = .paleGreen

        interestTagLabel.textAlignment = .center
        interestTagLabel.font = ._12CircularStdBook
        interestTagLabel.preferredMaxLayoutWidth = 120
        interestTagLabel.numberOfLines = 0
        interestTagLabel.textColor = .black
        contentView.addSubview(interestTagLabel)

        interestTagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with interest: Interest) {
        interestTagLabel.text = interest.name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
