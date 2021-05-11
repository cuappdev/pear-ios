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
    private var pair: User?
    private var profileSections = [ProfileSectionType]()
    private let profileTableView = UITableView(frame: .zero, style: .plain)
    private var reachOutButton = UIButton()
    private var userId: String

    // MARK: - Private Data Vars
    private let reachOutButtonSize = CGSize(width: 200, height: 50)

    init(userId: String) {
        self.userId = userId
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

        getUserThen { [weak self] pair in
            guard let self = self else { return }

            self.pair = pair

            self.setupViews(pair: pair)
            self.setupConstraints()

            self.profileSections = [.summary, .basics]
            if pair.interests.count > 0 {
                self.profileSections.append(.interests)
            }
            if pair.groups.count > 0 {
                self.profileSections.append(.groups)
            }
            self.profileTableView.reloadData()
        }
    }

    private func getUserThen(_ completion: @escaping (User) -> Void) {
        NetworkManager.shared.getUser(netId: userId).observe { result in
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        completion(response.data)
                    }
                case .error:
                    print("Network error: could not get user.")
                }
            }
        }
    }

    private func setupViews(pair: User) {

        profileTableView.dataSource = self
        profileTableView.backgroundColor = .clear
        profileTableView.register(ProfileSummaryTableViewCell.self, forCellReuseIdentifier: ProfileSummaryTableViewCell.reuseIdentifier)
        profileTableView.register(ProfileSectionTableViewCell.self, forCellReuseIdentifier: ProfileSectionTableViewCell.reuseIdentifier)
        profileTableView.register(ProfilePromptTableViewCell.self, forCellReuseIdentifier: ProfilePromptTableViewCell.reuseIdentifier)
        profileTableView.rowHeight = UITableView.automaticDimension
        profileTableView.bounces = true
        profileTableView.separatorStyle = .none
        profileTableView.estimatedSectionHeaderHeight = 0
        profileTableView.sectionHeaderHeight = UITableView.automaticDimension
        profileTableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 150, right: 0)
        profileTableView.showsVerticalScrollIndicator = false
        view.addSubview(profileTableView)

        reachOutButton.setTitle("Send email", for: .normal)
        reachOutButton.backgroundColor = .backgroundOrange
        reachOutButton.layer.cornerRadius = reachOutButtonSize.height / 2
        reachOutButton.titleLabel?.font = ._20CircularStdBold
        reachOutButton.setTitleColor(.white, for: .normal)
        reachOutButton.addTarget(self, action: #selector(reachOutPressed), for: .touchUpInside)

        view.addSubview(reachOutButton)

    }

    private func setupConstraints() {
        let reachOutPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 70)

        profileTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        reachOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(reachOutPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(reachOutButtonSize)
        }
    }

    @objc private func reachOutPressed() {
        guard let pair = pair else { return }
        let emailAlertController = UIAlertController.getEmailAlertController(
            email: "\(pair.netID)@cornell.edu",
            subject: "Hello from Pear!"
        )
        present(emailAlertController, animated: true)
    }

    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }

}

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pair = pair else { return UITableViewCell() }
        let section = profileSections[indexPath.row]
        let reuseIdentifier = section.reuseIdentifier

        switch section {
        case .summary:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSummaryTableViewCell else { return UITableViewCell() }
            cell.configure(for: nil, pair: pair)
            return cell
        case .basics:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfilePromptTableViewCell else { return UITableViewCell() }
            cell.configure(for: pair, type: section)
            return cell
        case .interests, .groups:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSectionTableViewCell else { return UITableViewCell() }
            cell.configure(for: pair, type: section)
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
