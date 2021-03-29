//
//  SelectPromptTableViewCell.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/28/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class SelectPromptTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let promptBackgroundView = UIView()
    private let promptLabel = UILabel()

    // MARK: - Data Vars
    static let reuseIdentifier = "SelectPromptTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        promptBackgroundView.backgroundColor = .white
        promptBackgroundView.layer.cornerRadius = 8
        promptBackgroundView.layer.masksToBounds = true
        promptBackgroundView.clipsToBounds = false
        promptBackgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        promptBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        promptBackgroundView.layer.shadowOpacity = 1
        promptBackgroundView.layer.shadowRadius = 4
        contentView.addSubview(promptBackgroundView)


        promptLabel.textColor = .black
        promptLabel.numberOfLines = 0
        promptLabel.font = ._16CircularStdBook
        promptBackgroundView.addSubview(promptLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        promptBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(8)
        }

        promptLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(promptBackgroundView).inset(12)
        }
    }

    func configure(for prompt: Prompt) {
        promptLabel.text = prompt.promptQuestion
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
