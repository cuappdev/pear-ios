//
//  HomeViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import GoogleSignIn
import SideMenu
import UIKit

class HomeViewController: UIViewController {

    private let logoutButton = UIButton()
    private let matchDemographicsLabel = UILabel()
    private let matchNameLabel = UILabel()
    private let matchProfileBackgroundView = UIStackView()
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
        let pronouns = "She/Her"
        let hometown = "Ithaca, NY"

        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(.textBlack, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
        view.addSubview(logoutButton)

        matchProfileBackgroundView.axis = .vertical
        matchProfileBackgroundView.spacing = 4
        view.addSubview(matchProfileBackgroundView)

        matchNameLabel.text = "\(firstName)\n\(lastName)"
        matchNameLabel.textColor = .textBlack
        matchNameLabel.numberOfLines = 0
        matchNameLabel.font = ._24CircularStdMedium
        matchProfileBackgroundView.insertArrangedSubview(matchNameLabel, at: 0)

        matchDemographicsLabel.text = "\(major) \(year)\nFrom \(hometown)\n\(pronouns)"
        matchDemographicsLabel.textColor = .textGreen
        matchDemographicsLabel.font = ._16CircularStdBook
        matchDemographicsLabel.numberOfLines = 0
        matchProfileBackgroundView.insertArrangedSubview(matchDemographicsLabel, at: 1)

        matchProfileImageView.backgroundColor = .inactiveGreen
        matchProfileImageView.layer.cornerRadius = imageSize.width/2
        view.addSubview(matchProfileImageView)

        matchSummaryTableView.backgroundColor = .backgroundLightGreen
        matchSummaryTableView.separatorStyle = .none
        matchSummaryTableView.showsVerticalScrollIndicator = false
        matchSummaryTableView.dataSource = self
        matchSummaryTableView.register(MatchSummaryTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        view.addSubview(matchSummaryTableView)

        profileButton.backgroundColor = .inactiveGreen
        profileButton.layer.cornerRadius = profileButtonSize.width/2
        profileButton.layer.shadowColor = UIColor.black.cgColor
        profileButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        profileButton.layer.shadowOpacity = 0.15
        profileButton.layer.shadowRadius = 2
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    private func setupConstraints() {
        let padding: CGFloat = 35 // TODO: Not sure about dimensions.
        let logoutPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 30) // TODO: Not sure about dimensions.
        let reachOutPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 70) // TODO: Not sure about dimensions.

        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(logoutPadding)
        }

        matchProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.size.equalTo(imageSize)
        }

        matchProfileBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(matchProfileImageView)
            make.leading.equalTo(matchProfileImageView.snp.trailing).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        matchSummaryTableView.snp.makeConstraints { make in
            make.top.equalTo(matchDemographicsLabel.snp.bottom).offset(padding)
            make.bottom.equalTo(reachOutButton.snp.top).offset(-padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(profileButtonSize)
        }

        reachOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(reachOutPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(reachOutButtonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
    }

    @objc private func profilePressed() {
        let menu = SideMenuNavigationController(rootViewController: ProfileMenuViewController())
        let presentationStyle: SideMenuPresentationStyle = .viewSlideOutMenuPartialIn
        presentationStyle.presentingEndAlpha = 0.85
        menu.presentationStyle = presentationStyle
        menu.leftSide = true
        menu.statusBarEndAlpha = 0
        menu.menuWidth = view.frame.width * 0.8
        present(menu, animated: true, completion: nil)
    }

    @objc private func logoutPressed() {
        GIDSignIn.sharedInstance().signOut()

        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }

    @objc private func reachOutPressed() {
        let timeVC = SchedulingTimeViewController(isConfirming: true, isPicking: false)
        navigationController?.pushViewController(timeVC, animated: true)
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

