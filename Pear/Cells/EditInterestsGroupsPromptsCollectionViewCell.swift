//
//  EditInterestsGroupsPromptsCollectionViewCell.swift
//  
//
//  Created by Mathew Scullin on 4/23/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class EditInterestsGroupsPromptsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EditInterestsGroupsPromptsCollectionViewCell"
    
    // MARK: - Private View Vars
    private let describtorLabel = UILabel()
    private let fadeTableView = FadeWrapperView(
        UITableView(frame: .zero, style: .grouped), fadeColor: .backgroundLightGreen
    )
    
    // MARK: - Private Data Vars
    private var tableViewContents = [Any]()
    private var editType: ProfileSectionType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundLightGreen
        
        describtorLabel.textColor = .black
        describtorLabel.font = ._20CircularStdBook
        contentView.addSubview(describtorLabel)
        
        fadeTableView.view.isScrollEnabled = true
        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.register(
            EditProfileTableViewCell.self,
            forCellReuseIdentifier: EditProfileTableViewCell.reuseIdentifier
        )
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.separatorStyle = .none
        fadeTableView.view.showsVerticalScrollIndicator = false
        fadeTableView.view.dataSource = self
        fadeTableView.view.delegate = self
        fadeTableView.view.rowHeight = UITableView.automaticDimension
        contentView.addSubview(fadeTableView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(editType: ProfileSectionType, currentUser: UserV2) {
        self.editType = editType
        switch editType {
        case .groups:
            describtorLabel.text = "Your groups"
            tableViewContents = currentUser.groups
            tableViewContents.append("Add groups")
        case .interests:
            describtorLabel.text = "Your interests"
            tableViewContents = currentUser.interests
            tableViewContents.append("Add groups")
        case .prompts:
            describtorLabel.text = "Your prompts"
            tableViewContents = currentUser.prompts
            if tableViewContents.count <= 3 {
                tableViewContents.append("Add groups")
            }
        default:
            tableViewContents = []
        }
        fadeTableView.view.reloadData()
    }
    
    private func setupConstraints() {
        describtorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(25)
        }
        
        fadeTableView.snp.makeConstraints { make in
            make.top.equalTo(describtorLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(36)
            make.bottom.equalToSuperview()
        }
    }
    
}

extension EditInterestsGroupsPromptsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch editType {
        case .groups:
            guard let cell = fadeTableView.view.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.reuseIdentifier) as? EditProfileTableViewCell, let group =  tableViewContents[indexPath.row] as? Group else { return UITableViewCell() }
            cell.configure(with: group)
            return cell
        case .interests:
            guard let cell = fadeTableView.view.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.reuseIdentifier) as? EditProfileTableViewCell, let interest =  tableViewContents[indexPath.row] as? Interest else { return UITableViewCell() }
            cell.configure(with: interest)
            return cell
        case .prompts:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    
}
