//
//  FeedbackCollectionViewCell.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class FeedbackCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let optionImage = UIImageView()
    private let optionLabel = UILabel()
    
    // MARK: - Private Data Vars
    static let reuseIdentifier = "feedbackReuseId"

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .pearGreen: .backgroundWhite
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .backgroundWhite
        contentView.layer.cornerRadius = 16
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)

        optionImage.isHidden = true
        contentView.addSubview(optionImage)

        optionLabel.textColor = .darkGreen
        optionLabel.font = UIFont.getFont(.book, size: 14)
        contentView.addSubview(optionLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let imageSize = CGSize(width: 10, height: 10)

        optionImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.size.equalTo(imageSize)
            make.centerY.equalToSuperview()
        }

        optionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(optionImage.snp.right).offset(12)
        }
    }

    private func resetConstraints() {
        optionLabel.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    func configure(for feedback: FeedbackOption) {
        if feedback.hasImage {
            optionImage.isHidden = false
            optionImage.image = UIImage(named: feedback.image)
        } else {
            optionImage.isHidden = true
            optionImage.image = UIImage()
            resetConstraints()
            if feedback.isRating {
                contentView.layer.cornerRadius = 18
            }
        }
        optionLabel.text = feedback.text
    }

}
