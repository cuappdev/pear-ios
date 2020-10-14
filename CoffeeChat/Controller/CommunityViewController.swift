//
//  CommunityViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    private let communityTableView = UITableView()
    private let users: [User] = [
        User(
            clubs: ["AppDev"],
            firstName: "Lucy",
            googleID: "12345",
            graduationYear: "2021",
            hometown: "Boston, MA",
            interests: ["Art"],
            lastName: "Xu",
            major: "Computer Science",
            matches: nil,
            netID: "llx2",
            profilePictureURL: "",
            pronouns: "She/her",
            facebook: nil,
            instagram: nil
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundLightGreen

        communityTableView.delegate = self
        communityTableView.dataSource = self
        communityTableView.separatorStyle = .none
        communityTableView.backgroundColor = .clear
        communityTableView.rowHeight = UITableView.automaticDimension
        communityTableView.estimatedRowHeight = 140
        communityTableView.setNeedsLayout()
        communityTableView.layoutIfNeeded()
        view.addSubview(communityTableView)

        setupConstraints()
    }

    private func setupConstraints() {
        communityTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
    }

}

extension CommunityViewController: UITableViewDelegate {

}

extension CommunityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}

