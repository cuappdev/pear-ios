//
//  ProfileViewController.swift
//  Pear
//
//  Created by Lucy Xu on 3/11/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

enum ProfileSectionType {
    case summary
    case basics
    case interests
    case groups
    case matches

    func getReuseIdentifier() -> String {
        switch self {
        case .summary:
            return ProfileSummaryTableViewCell.reuseIdentifier
        case .basics:
            return ProfilePromptTableViewCell.reuseIdentifier
        case .interests, .groups, .matches:
            return ProfileSectionTableViewCell.reuseIdentifier
        }
    }

    func getTitle(for user: User) -> String {
        switch self {
        case .summary:
            return "\(user.firstName) \(user.lastName)"
        case .basics:
            return "The basics"
        case .interests:
            return "Things I love"
        case .groups:
            return "Groups I'm a part of"
        case .matches:
            return "Pears I last chatted with"
        }
    }
}

class ProfileViewController: UIViewController {

    private let backButton = UIButton()
    private let profileTableView = UITableView(frame: .zero, style: .plain)
    private var user: User?
    private var userId: String
    private var userName: String
    private var profilePicture: String

    private var profileSections = [ProfileSectionType]()

    init(userId: String, userName: String, profilePicture: String) {
        self.userId = userId
        self.userName = userName
        self.profilePicture = profilePicture
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        profileTableView.delegate = self
        profileTableView.backgroundColor = .clear
        profileTableView.register(ProfileSummaryTableViewCell.self, forCellReuseIdentifier: ProfileSummaryTableViewCell.reuseIdentifier)
        profileTableView.register(ProfileSectionTableViewCell.self, forCellReuseIdentifier: ProfileSectionTableViewCell.reuseIdentifier)
        profileTableView.register(ProfilePromptTableViewCell.self, forCellReuseIdentifier: ProfilePromptTableViewCell.reuseIdentifier)
        profileTableView.rowHeight = UITableView.automaticDimension
        profileTableView.bounces = true
        profileTableView.separatorStyle = .none
        profileTableView.estimatedSectionHeaderHeight = 0
        profileTableView.sectionHeaderHeight = UITableView.automaticDimension
        profileTableView.showsVerticalScrollIndicator = false

        view.addSubview(profileTableView)

        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUser()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func setupConstraints() {
        profileTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func getUser() {
        NetworkManager.shared.getUser(netId: userId).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        self.profileSections = [.summary, .basics]
                        let user = response.data
                        self.user = user
                        if user.interests.count > 0 {
                            self.profileSections.append(.interests)
                        }
                        if user.groups.count > 0 {
                            self.profileSections.append(.groups)
                        }
                        self.profileTableView.reloadData()
                    }
                case .error:
                    print("Network error: could not get user.")
                }
            }
        }
    }


}

extension ProfileViewController: UITableViewDelegate {}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = user else { return UITableViewCell() }
        let section = profileSections[indexPath.row]
        let reuseIdentifier = section.getReuseIdentifier()

        switch section {
        case .summary:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSummaryTableViewCell else { return UITableViewCell() }
            cell.configure(for: user)
            return cell
        case .basics:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfilePromptTableViewCell else { return UITableViewCell() }
            cell.configure(for: user, type: section)
            return cell
        case .interests:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSectionTableViewCell else { return UITableViewCell() }
            cell.configure(for: user, type: section)
            return cell
        case .groups:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSectionTableViewCell else { return UITableViewCell() }
            cell.configure(for: user, type: section)
            return cell
        case .matches:
            return UITableViewCell()
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
