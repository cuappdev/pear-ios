//
//  PromptResponseView.swift
//  Pear
//
//  Created by Reade Plunkett on 9/23/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class PromptResponseView: UIView {
    
    // MARK: - Private View Vars
    private let questionLabel = UILabel()
    private let responseLabel = PromptLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabels() {
        questionLabel.font = ._12CircularStdMedium
        questionLabel.textColor = .greenGray
        questionLabel.numberOfLines = 0
        addSubview(questionLabel)

        responseLabel.textAlignment = .left
        responseLabel.font = ._16CircularStdBook
        responseLabel.backgroundColor = .paleGreen
        responseLabel.numberOfLines = 0
        responseLabel.textColor = .black
        responseLabel.layer.cornerRadius = 16
        responseLabel.clipsToBounds = true
        responseLabel.numberOfLines = 0
        responseLabel.lineBreakMode = .byWordWrapping
        responseLabel.adjustsFontSizeToFitWidth = false
        addSubview(responseLabel)
    }

    private func setupConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }

        responseLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview()
        }
    }

    func configure(for prompt: Prompt) {
        questionLabel.text = prompt.questionName
        responseLabel.text = prompt.answer ?? ""
        responseLabel.sizeToFit()
        responseLabel.layoutIfNeeded()
    }

}
