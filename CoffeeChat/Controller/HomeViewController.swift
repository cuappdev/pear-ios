//
//  HomeViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import GoogleSignIn
import UIKit

class HomeViewController: UIViewController {

    private let logoutButton = UIButton()
    private let matchDemographicsLabel = UILabel()
    private let matchNameLabel = UILabel()
    private let matchProfileImageView = UIImageView()
    private let matchSummaryTableView = UITableView()
    private let profileButton = UIButton()
    private let reachOutButton = UIButton()
    private let titleLabel = UILabel()

    private let imageSize = CGSize(width: 120, height: 120)
    private let profileButtonSize = CGSize(width: 35, height: 35)
    private let reachOutButtonSize = CGSize(width: 200, height: 50)
    private let cellReuseId = "cellReuseIdentifier"

    private var matchSummaries: [MatchSummary] = [
        // TODO: Remove after connecting to backend. These are temp values.
        MatchSummary(title: "You both love...", detail: "design and tech"),
        MatchSummary(title: "You're both part of...", detail: "AppDev"),
        MatchSummary(title: "He also enjoys...", detail: "music, reading, and business"),
        MatchSummary(title: "He is also part of...", detail: "EzraBox")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen

        // TODO: Remove after connecting to backend. These are temp values.
        let firstName = "Ezra"
        let lastName = "Cornell"
        let major = "Government"
        let year = 2020
        let hometown = "Ithaca, NY"

        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(.textBlack, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
        view.addSubview(logoutButton)

        matchDemographicsLabel.text = "\(major) \(year)\nFrom \(hometown)"
        matchDemographicsLabel.textColor = .textGreen
        matchDemographicsLabel.font = ._16CircularStdBook
        matchDemographicsLabel.numberOfLines = 0
        view.addSubview(matchDemographicsLabel)

        matchNameLabel.text = "\(firstName)\n\(lastName)"
        matchNameLabel.textColor = .textBlack
        matchNameLabel.numberOfLines = 0
        matchNameLabel.font = ._24CircularStdMedium
        view.addSubview(matchNameLabel)

        matchProfileImageView.backgroundColor = .backgroundGrayGreen
        matchProfileImageView.layer.cornerRadius = imageSize.width/2
        view.addSubview(matchProfileImageView)

        matchSummaryTableView.backgroundColor = .backgroundLightGreen
        matchSummaryTableView.separatorStyle = .none
        matchSummaryTableView.showsVerticalScrollIndicator = false
        matchSummaryTableView.dataSource = self
        matchSummaryTableView.register(MatchSummaryTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        view.addSubview(matchSummaryTableView)

        profileButton.backgroundColor = .backgroundGrayGreen
        profileButton.layer.cornerRadius = profileButtonSize.width/2
        profileButton.addTarget(self, action: #selector(profilePressed), for: .touchUpInside)
        view.addSubview(profileButton)

        reachOutButton.backgroundColor = .backgroundOrange
        reachOutButton.setTitle("Reach out!", for: .normal)
        reachOutButton.setTitleColor(.white, for: .normal)
        reachOutButton.titleLabel?.font = ._20CircularStdBold
        reachOutButton.layer.cornerRadius = reachOutButtonSize.height/2
        reachOutButton.addTarget(self, action: #selector(reachOutPressed), for: .touchUpInside)
        view.addSubview(reachOutButton)

        titleLabel.text = "Meet your Pear"
        titleLabel.textColor = .textBlack
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        let padding = 35

        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.centerX.equalToSuperview()
        }

        matchDemographicsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(matchNameLabel)
            make.top.equalTo(matchNameLabel.snp.bottom).offset(8)
        }

        matchNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(matchProfileImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(matchProfileImageView).offset(5)
        }

        matchProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.size.equalTo(imageSize)
        }

        matchSummaryTableView.snp.makeConstraints { make in
            make.top.equalTo(matchDemographicsLabel.snp.bottom).offset(padding)
            make.bottom.equalTo(reachOutButton.snp.top).offset(-padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(profileButtonSize)
        }

        reachOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.centerX.equalToSuperview()
            make.size.equalTo(reachOutButtonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }

    }

    @objc private func profilePressed() {
        print("profile pressed")
    }

    @objc private func logoutPressed() {
        GIDSignIn.sharedInstance().signOut()

        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }

    @objc private func reachOutPressed() {
        print("reach out pressed")
    }

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchSummaries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as? MatchSummaryTableViewCell else { return UITableViewCell() }
        let summary = matchSummaries[indexPath.row]
        cell.configure(for: summary)
        return cell
    }

}

