//
//  EditProfileSectionsViewController.swift
//  
//
//  Created by Mathew Scullin on 4/27/22.
//

import UIKit

enum EditProfileSectionType {
    case groups([Group])
    case interests([Interest])
    case prompts([Prompt])
    
    var descriptorLabelText: String {
        switch self {
        case .groups(_):
            return "groups"
        case .interests(_):
            return "interests"
        case .prompts(_):
            return "prompts"
        }
    }
}

class EditProfileSectionsViewController: UIViewController {
    
    // MARK: - Private View Vars
    private let descriptorLabel = UILabel()
    private let fadeTableView = FadeWrapperView(
        UITableView(frame: .zero, style: .grouped), fadeColor: .backgroundLightGreen
    )
    
    // MARK: - Private Data Vars
    private var editProfileSectionType: EditProfileSectionType
    private var prompts: [Prompt] = []
    private var promptOptions: [Prompt] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundLightGreen
        
        descriptorLabel.textColor = .black
        descriptorLabel.font = ._20CircularStdBook
        view.addSubview(descriptorLabel)
        
        fadeTableView.fadePositions = [.bottom]
        fadeTableView.view.isScrollEnabled = true
        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.register(
            EditProfileSectionTableViewCell.self,
            forCellReuseIdentifier: EditProfileSectionTableViewCell.reuseIdentifier
        )
        fadeTableView.view.register(
            AddProfileSectionTableViewCell.self,
            forCellReuseIdentifier: AddProfileSectionTableViewCell.reuseIdentifier
        )
        fadeTableView.view.register(
            PromptTableViewCell.self,
            forCellReuseIdentifier: PromptTableViewCell.reuseIdentifier
        )
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.separatorStyle = .none
        fadeTableView.view.showsVerticalScrollIndicator = false
        fadeTableView.view.dataSource = self
        fadeTableView.view.delegate = self
        fadeTableView.view.rowHeight = UITableView.automaticDimension
        fadeTableView.view.isScrollEnabled = true
        view.addSubview(fadeTableView)
        
        setupConstraints()
    }
    
    init(editProfileSectionType: EditProfileSectionType) {
        self.editProfileSectionType = editProfileSectionType
        descriptorLabel.text = "Your \(editProfileSectionType.descriptorLabelText)"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        descriptorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(25)
        }
        
        fadeTableView.snp.makeConstraints { make in
            make.top.equalTo(descriptorLabel.snp.bottom).inset(10)
            make.leading.trailing.equalToSuperview().inset(36)
            make.bottom.equalToSuperview()
        }
    }

}

extension EditProfileSectionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch editProfileSectionType {
        case .interests(let interests):
            return interests.count + 1
        case .groups(let groups):
            return groups.count + 1
        case .prompts(let prompts):
            return prompts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch editProfileSectionType {
        case .interests(let interests):
            guard let cell = fadeTableView.view.dequeueReusableCell(withIdentifier: EditProfileSectionTableViewCell.reuseIdentifier) as? EditProfileSectionTableViewCell, indexPath.row < interests.count else { return addProfileSectionTableViewCell(tableView, cellForRowAt: indexPath)
            }
            cell.configure(with: interests[indexPath.row])
            return cell
        case .groups(let groups):
            guard let cell = fadeTableView.view.dequeueReusableCell(withIdentifier: EditProfileSectionTableViewCell.reuseIdentifier) as? EditProfileSectionTableViewCell, indexPath.row < groups.count else { return addProfileSectionTableViewCell(tableView, cellForRowAt: indexPath)
            }
            cell.configure(with: groups[indexPath.row])
            return cell
        case .prompts(let prompts):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.reuseIdentifier, for: indexPath) as? PromptTableViewCell else { return UITableViewCell() }
            cell.configure(for: prompts[indexPath.row])
            cell.removePrompt = { [weak self] selectedCell in
                print("remove")
            }
            return cell
        }
    }
    
    private func addProfileSectionTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = fadeTableView.view.dequeueReusableCell(withIdentifier: AddProfileSectionTableViewCell.reuseIdentifier) as? AddProfileSectionTableViewCell else { return UITableViewCell() }
        cell.configure(with: "Add \(editProfileSectionType.descriptorLabelText)")
        return cell
    }
        
}

extension EditProfileSectionsViewController: UITableViewDelegate {
    
}
