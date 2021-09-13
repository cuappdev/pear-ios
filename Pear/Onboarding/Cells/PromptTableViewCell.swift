//
//  ProfilePromptsTableViewCell.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 8/17/21.
//  Copyright © 2021 cuappdev. All rights reserved.

import UIKit

class PromptTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let promptBackgroundView = UIView()
    private let promptLabel = UILabel()
    private let removePromptButton = UIButton()
    private let promptResponseLabel = UILabel()
    private let selectLabel = UILabel()
    private let selectImageView = UIImageView()

    // MARK: - Data Vars
    var removePrompt: ((PromptTableViewCell) -> ())?
    static let reuseIdentifier = "PromptTableViewCell"

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

        selectLabel.text = "Select a prompt"
        selectLabel.font = ._16CircularStdBook
        selectLabel.textColor = .inactiveGreen
        promptBackgroundView.addSubview(selectLabel)

        selectImageView.contentMode = .scaleAspectFit
        selectImageView.image = UIImage(named: "add")
        selectImageView.clipsToBounds = true
        promptBackgroundView.addSubview(selectImageView)

        promptLabel.font = ._12CircularStdBook
        promptLabel.numberOfLines = 0
        promptLabel.textColor = .darkGreen
        promptBackgroundView.addSubview(promptLabel)

        promptResponseLabel.font = ._16CircularStdBook
        promptResponseLabel.numberOfLines = 0
        promptResponseLabel.textColor = .black
        promptBackgroundView.addSubview(promptResponseLabel)

        removePromptButton.setImage(UIImage(named: "cancelled"), for: .normal)
        removePromptButton.addTarget(self, action: #selector(handleRemovePrompt), for: .touchUpInside)
        promptBackgroundView.addSubview(removePromptButton)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func handleRemovePrompt() {
        if let removePrompt = removePrompt {
            removePrompt(self)
        }
    }

    private func setupConstraints() {
        promptBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(8)
        }

        selectLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        selectImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        promptLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.width.equalTo(235)
        }

        promptResponseLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalTo(promptLabel.snp.bottom).offset(12)
        }

        removePromptButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(promptLabel.snp.top)
        }
    }

    func configure(for prompt: Prompt) {
        let answer = prompt.answer ?? ""
        promptLabel.text = prompt.questionName
        promptResponseLabel.text = answer
        selectLabel.isHidden = !answer.isEmpty
        selectImageView.isHidden = !answer.isEmpty
        promptLabel.isHidden = answer.isEmpty
        promptResponseLabel.isHidden = answer.isEmpty
        removePromptButton.isHidden = answer.isEmpty
    }

}
