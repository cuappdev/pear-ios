//
//  ProfileViewController.swift
//  Pear
//
//  Created by Lucy Xu on 3/11/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileTableView = UITableView(frame: .zero, style: .plain)
    private var user: User?
    private var userId: String
    private var userName: String
    private var profilePicture: String

    init(userId: String, userName: String, profilePicture: String) {
        self.userId = userId
        self.userName = userName
        self.profilePicture = profilePicture
        super.init(nibName: nil, bundle: nil)
        print(userId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundLightGreen

        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.backgroundColor = .clear
        profileTableView.register(ProfileSummaryTableViewCell.self, forCellReuseIdentifier: ProfileSummaryTableViewCell.reuseIdentifier)
        profileTableView.rowHeight = UITableView.automaticDimension
        profileTableView.bounces = true
        profileTableView.separatorStyle = .none
        profileTableView.estimatedSectionHeaderHeight = 0
        profileTableView.sectionHeaderHeight = UITableView.automaticDimension
        profileTableView.showsVerticalScrollIndicator = false

        view.addSubview(profileTableView)

        setupConstraints()
    }

    private func setupConstraints() {

        profileTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }


}

extension ProfileViewController: UITableViewDelegate {

}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSummaryTableViewCell.reuseIdentifier, for: indexPath) as? ProfileSummaryTableViewCell else { return UITableViewCell() }
        cell.configure(userId: userId, userName: userName, profileImage: profilePicture)
        return cell

    }


}
