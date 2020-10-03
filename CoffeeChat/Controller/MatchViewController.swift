//
//  MatchViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import GoogleSignIn
import UIKit

class MatchViewController: UIViewController {

    private let matchDemographicsLabel = UILabel()
    private let matchNameLabel = UILabel()
    private let matchProfileImageView = UIImageView()
    private let matchSummaryTableView = UITableView()
    private let reachOutButton = UIButton()

    private let imageSize = CGSize(width: 120, height: 120)
    private let reachOutButtonSize = CGSize(width: 200, height: 50)

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

        matchDemographicsLabel.text = "\(major) \(year)\nFrom \(hometown)"
        matchDemographicsLabel.textColor = .textGreen
        matchDemographicsLabel.font = ._16CircularStdBook
        matchDemographicsLabel.numberOfLines = 0
        view.addSubview(matchDemographicsLabel)

        matchNameLabel.text = "\(firstName)\n\(lastName)"
        matchNameLabel.textColor = .black
        matchNameLabel.numberOfLines = 0
        matchNameLabel.font = ._24CircularStdMedium
        view.addSubview(matchNameLabel)

        matchProfileImageView.backgroundColor = .inactiveGreen
        matchProfileImageView.layer.cornerRadius = imageSize.width/2
        view.addSubview(matchProfileImageView)

        matchSummaryTableView.backgroundColor = .backgroundLightGreen
        matchSummaryTableView.separatorStyle = .none
        matchSummaryTableView.showsVerticalScrollIndicator = false
        matchSummaryTableView.isScrollEnabled = false
        matchSummaryTableView.dataSource = self
        matchSummaryTableView.register(MatchSummaryTableViewCell.self, forCellReuseIdentifier: MatchSummaryTableViewCell.reuseIdentifier)
        view.addSubview(matchSummaryTableView)

        reachOutButton.backgroundColor = .backgroundOrange
        reachOutButton.setTitle("Reach out!", for: .normal)
        reachOutButton.setTitleColor(.white, for: .normal)
        reachOutButton.titleLabel?.font = ._20CircularStdBold
        reachOutButton.layer.cornerRadius = reachOutButtonSize.height/2
        reachOutButton.addTarget(self, action: #selector(reachOutPressed), for: .touchUpInside)
        view.addSubview(reachOutButton)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    private func setupConstraints() {
        let padding: CGFloat = 35 // TODO: Not sure about dimensions.
        let reachOutPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 70) // TODO: Not sure about dimensions.

        matchDemographicsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(matchNameLabel)
            make.top.equalTo(matchNameLabel.snp.bottom).offset(8)
        }

        matchNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(matchProfileImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(matchProfileImageView).offset(6)
        }

        matchProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalToSuperview().offset(27)
            make.size.equalTo(imageSize)
        }

        matchSummaryTableView.snp.makeConstraints { make in
            make.top.equalTo(matchDemographicsLabel.snp.bottom).offset(padding)
            make.bottom.equalTo(reachOutButton.snp.top).offset(-padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        reachOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(reachOutPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(reachOutButtonSize)
        }

    }

    @objc private func reachOutPressed() {
        let timeVC = SchedulingTimeViewController(isConfirming: true, isPicking: false)
        navigationController?.pushViewController(timeVC, animated: true)
    }
}

extension MatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchSummaries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchSummaryTableViewCell.reuseIdentifier, for: indexPath) as? MatchSummaryTableViewCell else { return UITableViewCell() }
        let summary = matchSummaries[indexPath.row]
        cell.configure(for: summary)
        return cell
    }

}

