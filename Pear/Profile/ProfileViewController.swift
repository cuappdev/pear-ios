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
    private var currentUser: UserV2
    private var otherUser: UserV2?
    private var profileSections = [ProfileSectionType]()
    private let profileTableView = UITableView(frame: .zero, style: .plain)
    
    init(user: UserV2) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
        setupView(for: self.currentUser)
        navigationItem.title = "Preview"
        let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonPressed))
        editButton.setTitleTextAttributes([
            .font: UIFont.getFont(.medium, size: 20)
        ], for: .normal)
        editButton.tintColor = .darkGreen
        navigationItem.rightBarButtonItem = editButton
    }

    init(user: UserV2, otherUserId: Int) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
        getOtherUser(otherUserId: otherUserId)
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
        setupConstraints()
    }

    private func getOtherUser(otherUserId: Int) {
        NetworkManager.getUser(id: otherUserId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.otherUser = user
                    self.setupView(for: user)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupView(for user: UserV2) {
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
    
    @objc private func editButtonPressed() {
        let editProfileVC = EditDemographicsViewController(user: currentUser)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }

}

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = otherUser ?? currentUser
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
