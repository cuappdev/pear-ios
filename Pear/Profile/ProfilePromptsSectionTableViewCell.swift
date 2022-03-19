//
//  ProfilePromptsTableViewCell.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 8/17/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class ProfilePromptsSectionTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let promptsView = UIStackView()

    // MARK: - Private Data Vars
    private var prompts: [Prompt] = []

    static let reuseIdentifier = "ProfilePromptsSectionTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .black
        
        setupPromptsView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPromptsView() {
        promptsView.axis = .vertical
        promptsView.distribution = .fill
        promptsView.spacing = 0
        contentView.addSubview(promptsView)
    }

    private func setupConstraints() {
        promptsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(20)
        }
    }

    func configure(for prompts: [Prompt]) {
        guard promptsView.arrangedSubviews.isEmpty else {
            return
        }
        
        self.prompts = prompts
        
        prompts.forEach { prompt in
            let promptView = PromptResponseView()
            promptView.configure(for: prompt)
            promptsView.addArrangedSubview(promptView)
        }
    }

}
