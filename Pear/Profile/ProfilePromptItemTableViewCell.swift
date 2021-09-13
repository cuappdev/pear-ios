//
//  ProfilePromptItemTableViewCell.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 8/17/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class ProfilePromptItemTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let questionLabel = UILabel()
    private let responseLabel = PromptLabel()

    // MARK: - Private Data Vars
    static let reuseIdentifier = "ProfilePromptItemTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        questionLabel.font = ._12CircularStdMedium
        questionLabel.textColor = .greenGray
        questionLabel.numberOfLines = 0
        contentView.addSubview(questionLabel)

        responseLabel.textAlignment = .left
        responseLabel.font = ._16CircularStdBook
        responseLabel.backgroundColor = .paleGreen
        responseLabel.numberOfLines = 0
        responseLabel.textColor = .black
        responseLabel.layer.cornerRadius = 16
        responseLabel.clipsToBounds = true
        responseLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(responseLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }

        responseLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
        }
    }

    func configure(for prompt: Prompt) {
        questionLabel.text = prompt.questionName
        responseLabel.text = prompt.answer ?? ""
        responseLabel.sizeToFit()
        responseLabel.layoutIfNeeded()
    }

}
