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
    private let promptsTableView = SelfSizingTableView()

    // MARK: - Private Data Vars
    private var prompts: [Prompt] = []

    static let reuseIdentifier = "ProfilePromptsSectionTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        promptsTableView.dataSource = self
        promptsTableView.delegate = self
        promptsTableView.backgroundColor = .clear
        promptsTableView.register(ProfilePromptItemTableViewCell.self, forCellReuseIdentifier: ProfilePromptItemTableViewCell.reuseIdentifier)
        promptsTableView.estimatedRowHeight = 65
        promptsTableView.rowHeight = UITableView.automaticDimension
        promptsTableView.bounces = false
        promptsTableView.layoutIfNeeded()
        promptsTableView.showsVerticalScrollIndicator = false
        promptsTableView.separatorStyle = .none
        contentView.addSubview(promptsTableView)

        setupConstraints(for: 0)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints(for height: CGFloat) {
        promptsTableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(height)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    func configure(for prompts: [Prompt]) {
        self.prompts = prompts
        self.promptsTableView.reloadData()
        self.promptsTableView.layoutIfNeeded()
        print(self.promptsTableView.contentSize.height)
        self.setupConstraints(for: self.promptsTableView.contentSize.height)
    }

}

extension ProfilePromptsSectionTableViewCell: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prompts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePromptItemTableViewCell.reuseIdentifier, for: indexPath) as? ProfilePromptItemTableViewCell else { return UITableViewCell() }
        let prompt = prompts[indexPath.row]
        cell.configure(for: prompt)
        return cell
    }


}
