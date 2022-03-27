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

class ProfileViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let menuButton = UIButton()
    private var currentUser: UserV2
    private var otherUser: CommunityUser?
    private var profileSections = [ProfileSectionType]()
    private let profileTableView = UITableView(frame: .zero, style: .plain)
    private var optionsMenuView: OptionsView?
    
    // MARK: - Private Data Vars
    private var displayMenu = true
    
    init(user: UserV2, otherUser: CommunityUser) {
        self.currentUser = user
        self.otherUser = otherUser
        super.init(nibName: nil, bundle: nil)
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
            .font: UIFont.getFont(.medium, size: 24)
        ]
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        menuButton.setImage(UIImage(named: "optionicon"), for: .normal)
        menuButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)

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
        profileTableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
        profileTableView.showsVerticalScrollIndicator = false
        view.addSubview(profileTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        let isBlocked = true
        if !isBlocked {
            setupProfile()
        } else {
            setupBlockedProfile()
        }
        setupConstraints()
    }
    private func setupBlockedProfile() {
        self.profileSections = [.summary]
        menuButton.isHidden = true
        
        let unblockButton = DynamicButton()
        unblockButton.setTitle("Unblock", for: .normal)
        unblockButton.setTitleColor(.white, for: .normal)
        unblockButton.titleLabel?.font = ._20CircularStdBold
        unblockButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2
        unblockButton.backgroundColor = .backgroundOrange
        unblockButton.isEnabled = true
        unblockButton.addTarget(self, action: #selector(unblockedButtonPressed), for: .touchUpInside)
        view.addSubview(unblockButton)
        
        let unblockLabel = UILabel()
        unblockLabel.text = "This user is currently blocked."
        unblockLabel.font = ._18CircularStdBook
        unblockLabel.textAlignment = .center
        unblockLabel.numberOfLines = 0
        unblockLabel.textColor = .darkGreen
        view.addSubview(unblockLabel)
        
        let unblockLabelSize = CGSize(width: 280, height: 25)
        let unblockButtonSize = CGSize(width: 196, height: 53)
        
        unblockLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
            make.size.equalTo(unblockLabelSize)
        }
        
        unblockButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(unblockLabel.snp.bottom).offset(12)
            make.size.equalTo(unblockButtonSize)
        }
    }

    private func setupProfile() {
        guard let user = otherUser else { return }
        self.profileSections = [.summary, .basics]
        
        if !user.interests.isEmpty {
            self.profileSections.append(.interests)
        }
        
        if !user.groups.isEmpty {
            self.profileSections.append(.groups)
        }
        
        if !user.prompts.isEmpty {
            self.profileSections.append(.prompts)
        }
        
        self.profileTableView.reloadData()
    }

    private func setupConstraints() {
        profileTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func unblockedButtonPressed() {
        guard let userId = otherUser?.id else { return }
        let unblockUserView = BlockUserView(userId: userId, isBlocking: false)
        Animations.presentPopUpView(superView: view, popUpView: unblockUserView)
    }
    
    @objc private func dismissMenu() {
        if !displayMenu {
            optionsMenuView?.removeFromSuperview()
            displayMenu.toggle()
        }
    }
    
    @objc private func toggleMenu() {
        if displayMenu {
            guard let superView = navigationController?.view, let otherUserId = otherUser?.id else { return }
            let options = ["Block user"]
            optionsMenuView = OptionsView(
                feedbackDelegate: nil,
                matchId: otherUserId,
                options: options,
                superView: superView
            )
            
            guard let optionsMenuView = optionsMenuView else { return }
            view.addSubview(optionsMenuView)

            optionsMenuView.snp.makeConstraints { make in
                make.top.equalTo(menuButton.snp.bottom).offset(8)
                make.trailing.equalTo(view.snp.trailing).offset(-25)
                make.size.equalTo(CGSize(width: 150, height: 50))
            }
        } else {
            optionsMenuView?.removeFromSuperview()
        }
        displayMenu.toggle()
    }

}

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = otherUser else { return UITableViewCell() }
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
         }
         return false
     }

  }
