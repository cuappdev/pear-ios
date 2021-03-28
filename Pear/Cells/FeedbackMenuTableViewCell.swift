
//
//  FeedbackMenuTableViewCell.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/21/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//
import UIKit

class FeedbackMenuTableViewCell: UITableViewCell {

    static let reuseIdentifier = "FeedbackMenuTableViewCell"
    private let feedbackOptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundWhite
        selectionStyle = .none

        feedbackOptionLabel.textColor = .black
        feedbackOptionLabel.font = ._16CircularStdBook
        contentView.addSubview(feedbackOptionLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        feedbackOptionLabel.snp.makeConstraints { make in
            make.center.equalTo(contentView.snp.center)
        }
    }

    func configure(for feedbackOption: String) {
        feedbackOptionLabel.text = feedbackOption
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
