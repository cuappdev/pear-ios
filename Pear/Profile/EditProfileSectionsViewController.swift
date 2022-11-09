//
//  EditProfileSectionsViewController.swift
//  
//
//  Created by Mathew Scullin on 4/27/22.
//

import UIKit

protocol CreateNewPromptDelegate: AnyObject {
    func addPrompt(newPrompt: Prompt)
}

protocol EditProfileDelegate: AnyObject {
    func updateInterests(updatedUser: UserV2, newInterests: [Interest])
    func updateGroups(updatedUser: UserV2, newGroups: [Group])
    func updatePrompts(updatedUser: UserV2, newPrompt: Prompt)
}

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
    private var delegate: didEditProfileDelegate?
    private var interests: [Interest] = []
    private var groups: [Group] = []
    private var updatingUser: UserV2
    private var prompts: [Prompt] = []
    private var promptOptions: [Prompt] = []
    private var indexOfPrompt: Int = 0 // Stores the index of the prompt that was clicked

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
    
    init(editProfileSectionType: EditProfileSectionType, delegate: didEditProfileDelegate, currentUser: UserV2) {
        self.delegate = delegate
        self.editProfileSectionType = editProfileSectionType
        self.updatingUser = currentUser
        descriptorLabel.text = "Your \(editProfileSectionType.descriptorLabelText)"
        /// Initialize the global variables using the passed in Enum, for interests, groups, and prompts so that they can
        /// be used as the tableView's datasource
        switch editProfileSectionType {
        case .interests(let interests):
            self.interests = interests
        case .groups(let groups):
            self.groups = groups
        case .prompts(let prompts):
            self.prompts = prompts
        }
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
        case .interests:
            return interests.count + 1
        case .groups:
            return groups.count + 1
        case .prompts:
            return prompts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch editProfileSectionType {
        case .interests:
            guard let cell = fadeTableView.view.dequeueReusableCell(withIdentifier: EditProfileSectionTableViewCell.reuseIdentifier) as? EditProfileSectionTableViewCell, indexPath.row < interests.count else { return addProfileSectionTableViewCell(tableView, cellForRowAt: indexPath)
            }
            cell.configure(with: interests[indexPath.row], user: updatingUser, index: indexPath.row, delegate: self)
            return cell
        case .groups:
            guard let cell = fadeTableView.view.dequeueReusableCell(withIdentifier: EditProfileSectionTableViewCell.reuseIdentifier) as? EditProfileSectionTableViewCell,
                    indexPath.row < groups.count else { return addProfileSectionTableViewCell(tableView, cellForRowAt: indexPath)
            }
            cell.configure(with: groups[indexPath.row], user: updatingUser, index: indexPath.row, delegate: self)
            return cell
        case .prompts:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.reuseIdentifier, for: indexPath) as? PromptTableViewCell else { return UITableViewCell() }
            cell.configure(for: prompts[indexPath.row])
                cell.removePrompt = { [weak self] selectedCell in
                    guard let self = self else { return }
                    guard let indexPath = self.fadeTableView.view.indexPath(for: cell) else { return }
                    self.prompts[indexPath.row] = Prompt(id: nil, questionName: "", questionPlaceholder: "", answer: nil)
                    /// Pass this indexOfPrompt into the updating VC (when it's pushed) and then when passed back from the delegate, we need to update the self.prompts array at this specific index
                    self.indexOfPrompt = indexPath.row
                }
            NetworkManager.getPromptOptions { prompts in
                DispatchQueue.main.async {
                    self.promptOptions = prompts.filter { !self.prompts.contains($0) }
                    self.fadeTableView.view.reloadData()
                }
            }
            return cell
        }
    }
    
    /// If user selects the last row of the section, we need to push the adding controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch editProfileSectionType {
        case .interests:
            if indexPath.row == interests.count {
                // Push new addInterestVC
                navigationController?.pushViewController(InterestSettingsViewController(updatingUser: updatingUser, delegate: self), animated: true)
            }
        case .groups:
            if indexPath.row == groups.count {
                navigationController?.pushViewController(GroupsSettingsViewController(updatingUser: updatingUser, delegate: self), animated: true)
            }
        case .prompts:
            /// Pushes the prompt options VC here
            let prompt = prompts[indexPath.row]
            let answer = prompt.answer ?? ""
            if !answer.isEmpty {
                /// User editing a pre-existing prompt's answers
                let answerPromptViewController = PromptAnswersSettingsViewController(updatingUser: updatingUser, delegate: self, prompt: prompt, addPrompt: { (prompt, index)in
                }, index: indexPath.row)
                indexOfPrompt = indexPath.row
                navigationController?.pushViewController(answerPromptViewController, animated: true)
            } else {
                /// Answer is empty, so User adding a new prompt + answer
                let selectPromptViewController = SelectPromptsSettingsViewController(delegate: self, prompts: promptOptions, addPrompt: { (prompt, index) in
                }, index: indexPath.row)
                /// Adding a new prompt + question combo
                indexOfPrompt = indexPath.row
                navigationController?.pushViewController(selectPromptViewController, animated: true)
            }
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

extension EditProfileSectionsViewController: EditProfileDelegate {
    
    func updateInterests(updatedUser: UserV2, newInterests: [Interest]) {
        /// Update the global "interests" variable with the newly edited [Interest] that was passed in from the InterestSettingsVC + newly updated User
        self.interests = newInterests
        self.updatingUser = updatedUser
        /// Network call to update the user's interest on the backend
        let selectedInterestsIds = self.interests.map { $0.id }
        NetworkManager.updateInterests(interests: selectedInterestsIds) { [weak self] (success) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !success {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
        /// Passing the updatedUser back to the EditProfileViewController to reflect the change in this session
        delegate?.updateUser(updatedUser: updatingUser)
        self.fadeTableView.view.reloadData()
    }
    
    func updateGroups(updatedUser: UserV2, newGroups: [Group]) {
        self.groups = newGroups
        self.updatingUser = updatedUser
        /// Network call to update the user's groups on the backend
        let selectedGroupsIds = self.groups.map { $0.id }
        NetworkManager.updateGroups(groups: selectedGroupsIds) { [weak self] (success) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !success {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
        delegate?.updateUser(updatedUser: updatingUser)
        self.fadeTableView.view.reloadData()
    }
    
    func updatePrompts(updatedUser: UserV2, newPrompt: Prompt) {
        // Set global variable prompt
        self.prompts = updatedUser.prompts
        // Set the user in this to this passed in user
        self.updatingUser = updatedUser
        delegate?.updateUser(updatedUser: self.updatingUser)
    }
    
}

/// Used for when the user is adding a new prompt and creating a new answer for it, rather than editing an existing one.
extension EditProfileSectionsViewController: CreateNewPromptDelegate {
    
    func addPrompt(newPrompt: Prompt) {
        self.prompts[indexOfPrompt] = newPrompt
        self.updatingUser.prompts = self.prompts
        fadeTableView.view.reloadData()
        delegate?.updateUser(updatedUser: self.updatingUser)
    }
}
