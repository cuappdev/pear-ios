//
//  ProfileViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//
import GoogleSignIn
import Kingfisher
import UIKit

protocol didUpdateProfileViewDelegate {
    func updateProfileUser(updatedUser: UserV2)
}

enum ProfileViewing: Equatable {
    case currentUser
    case otherUser(Int)
}

class ProfileViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let menuButton = UIButton()
    private let unblockButton = DynamicButton()
    private let unblockLabel = UILabel()
    private let editButton = UIButton()
    private var profileSections = [ProfileSectionType]()
    private let profileTableView = UITableView(frame: .zero, style: .plain)
    private var optionsMenuView: OptionsView?
    private let viewType: ProfileViewing
    
    // MARK: - Private Data Vars
    private var currentUser: UserV2
    private var profileUser: CommunityUser?
    private var shouldDisplayMenu = true
    
    init(user: UserV2, viewType: ProfileViewing) {
        self.currentUser = user
        self.viewType = viewType
        super.init(nibName: nil, bundle: nil)
        switch viewType {
            case .currentUser:
                getProfileUser(profileUserId: currentUser.id)
            case .otherUser(let otherUserId):
                getProfileUser(profileUserId: otherUserId)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundLightGreen

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.shadowImage = UIImage() // Hide navigation bar bottom shadow
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont._24CircularStdMedium,
            .foregroundColor: UIColor.primaryText
        ]
        navigationItem.title = viewType == .currentUser ? "Preview" : ""
        
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.darkGreen, for: .normal)
        editButton.titleLabel?.font = ._20CircularStdMedium
        editButton.isHidden = viewType != .currentUser
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)

        menuButton.setImage(UIImage(named: "optionIcon"), for: .normal)
        menuButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        menuButton.isHidden = viewType == .currentUser
        
        switch viewType {
            case .currentUser:
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
        case .otherUser(_):
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        }

        profileTableView.dataSource = self
        profileTableView.backgroundColor = .clear
        profileTableView.register(ProfileSummaryTableViewCell.self, forCellReuseIdentifier: ProfileSummaryTableViewCell.reuseIdentifier)
        profileTableView.register(ProfileSectionTableViewCell.self, forCellReuseIdentifier: ProfileSectionTableViewCell.reuseIdentifier)
        profileTableView.register(ProfilePromptTableViewCell.self, forCellReuseIdentifier: ProfilePromptTableViewCell.reuseIdentifier)
        profileTableView.register(ProfilePromptsSectionTableViewCell.self, forCellReuseIdentifier: ProfilePromptsSectionTableViewCell.reuseIdentifier)
        profileTableView.rowHeight = UITableView.automaticDimension
        profileTableView.bounces = true
        profileTableView.separatorStyle = .none
        profileTableView.estimatedSectionHeaderHeight = 0
        profileTableView.sectionHeaderHeight = UITableView.automaticDimension
        profileTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        profileTableView.showsVerticalScrollIndicator = false
        view.addSubview(profileTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        setupConstraints()
    }
    
    private func getProfileUser(profileUserId: Int) {
        NetworkManager.getUser(id: profileUserId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.profileUser = user
                    if let blocked = self.profileUser?.isBlocked as? Bool, blocked {
                        self.setupBlockedProfile()
                    } else {
                        self.setupProfile()
                    }
                    self.profileTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
            
    private func setupBlockedProfile() {
        profileSections = [.summary]
        menuButton.isHidden = true
        unblockButton.isHidden = false
        unblockLabel.isHidden = false
        profileTableView.isScrollEnabled = false
        
        unblockButton.setTitle("Unblock", for: .normal)
        unblockButton.setTitleColor(.white, for: .normal)
        unblockButton.titleLabel?.font = ._20CircularStdBold
        unblockButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2
        unblockButton.backgroundColor = .backgroundOrange
        unblockButton.isEnabled = true
        unblockButton.addTarget(self, action: #selector(unblockedButtonPressed), for: .touchUpInside)
        view.addSubview(unblockButton)
        
        unblockLabel.text = "This user is currently blocked."
        unblockLabel.font = ._18CircularStdBook
        unblockLabel.textAlignment = .center
        unblockLabel.numberOfLines = 0
        unblockLabel.textColor = .darkGreen
        view.addSubview(unblockLabel)
        
        let unblockButtonSize = CGSize(width: 196, height: 53)
        
        unblockLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
        
        unblockButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(unblockLabel.snp.bottom).offset(12)
            make.size.equalTo(unblockButtonSize)
        }
    }

    private func setupProfile() {
        guard let user = profileUser else { return }
        profileSections = [.summary, .basics]
        menuButton.isHidden = false
        unblockButton.isHidden = true
        unblockLabel.isHidden = true
        profileTableView.isScrollEnabled = true
        
        if !user.interests.isEmpty {
            profileSections.append(.interests)
        }
        
        if !user.groups.isEmpty {
            profileSections.append(.groups)
        }
        
        if !user.prompts.isEmpty {
            profileSections.append(.prompts)
        }
    }

    private func setupConstraints() {
        profileTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editPressed() {
        let editProfileVC = EditProfileViewController(currentUser: currentUser, delegate: self)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
        
    @objc private func unblockedButtonPressed() {
        guard let userId = profileUser?.id else { return }
        let unblockUserView = BlockUserView(blockDelegate: self, userId: userId, isBlocking: false)
        Animations.presentPopUpView(superView: view, popUpView: unblockUserView)
    }
    
    @objc private func dismissMenu() {
        if !shouldDisplayMenu {
            optionsMenuView?.removeFromSuperview()
            shouldDisplayMenu.toggle()
        }
    }
    
    @objc private func toggleMenu() {
        let optionsMenuViewSize = CGSize(width: 150, height: 50)
        let optionsMenuViewPadding = 8
        
        if shouldDisplayMenu {
            guard let superView = navigationController?.view, let profileUserId = profileUser?.id else { return }
        
            optionsMenuView = OptionsView(
                feedbackDelegate: nil,
                blockDelegate: self,
                matchId: profileUserId,
                blockId: profileUserId,
                options: ["Block user"],
                superView: superView
            )
            
            guard let optionsMenuView = optionsMenuView else { return }
            view.addSubview(optionsMenuView)

            optionsMenuView.snp.makeConstraints { make in
                make.top.equalTo(menuButton.snp.bottom).offset(optionsMenuViewPadding)
                make.trailing.equalTo(view.snp.trailing).inset(4 * optionsMenuViewPadding)
                make.size.equalTo(optionsMenuViewSize)
            }
        } else {
            optionsMenuView?.removeFromSuperview()
        }
        shouldDisplayMenu.toggle()
    }

}

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = profileUser else { return UITableViewCell() }
        let section = profileSections[indexPath.row]
        let reuseIdentifier = section.reuseIdentifier
        
        switch section {
            case .summary:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSummaryTableViewCell else { return UITableViewCell() }
                cell.configure(for: user)
                return cell
            case .basics:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfilePromptTableViewCell else { return UITableViewCell() }
                cell.configure(for: user, type: section)
                return cell
            case .interests, .groups:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSectionTableViewCell else { return UITableViewCell() }
                cell.configure(for: user, type: section)
                return cell
            case .matches:
                return UITableViewCell()
            case .prompts:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfilePromptsSectionTableViewCell else { return UITableViewCell() }
                cell.configure(for: user.prompts)
                return cell
        }
    }

}

extension ProfileViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
             navigationController?.popViewController(animated: true)
        } else if gestureRecognizer.view == view {
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !(touch.view is UIButton)
    }

}

extension ProfileViewController: BlockDelegate {
    
    func presentErrorAlert() {
        present(UIAlertController.getStandardErrortAlert(), animated: true)
    }
    
    func didBlockOrUnblockUser() {
        guard let profileUserId = profileUser?.id else { return }
        getProfileUser(profileUserId: profileUserId)
    }
}

/// Updating the currently displayed ProfileUser with the proper fields. Very wordy because profileUser is of type CommunityUser.
extension ProfileViewController: didUpdateProfileViewDelegate {
    
    func updateProfileUser(updatedUser: UserV2) {
        self.currentUser = updatedUser
        self.profileUser?.interests = updatedUser.interests
        self.profileUser?.groups = updatedUser.groups
        self.profileUser?.prompts = updatedUser.prompts
        
        self.profileUser?.firstName = updatedUser.firstName
        self.profileUser?.lastName = updatedUser.lastName
        self.profileUser?.pronouns = updatedUser.pronouns
        self.profileUser?.majors = updatedUser.majors
        self.profileUser?.profilePicUrl = updatedUser.profilePicUrl
        
        profileTableView.reloadData()
        
        // Update user's information on the backened
        if let graduationYear = updatedUser.graduationYear, let hometown = updatedUser.hometown, let pronouns = updatedUser.pronouns {
            self.profileUser?.graduationYear = graduationYear
            self.profileUser?.hometown = hometown

            NetworkManager.updateProfileSettings(
                firstName: updatedUser.firstName,
                lastName: updatedUser.lastName,
                graduationYear: graduationYear,
                majors: [updatedUser.majors[0].id],
                hometown: hometown,
                pronouns: pronouns,
                profilePicUrl: updatedUser.profilePicUrl) { success in
                }
        }
        
        NetworkManager.updatePrompts(prompts: updatedUser.prompts) { success in
            DispatchQueue.main.async {
                if !success {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
        
    }
}
