//
//  MatchViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import GoogleSignIn
import UIKit

enum PairingProgress {
    case reachingOut
    case waitingOnResponse
    case responding
    case dateScheduled
}

class MatchViewController: UIViewController {

    private let pairingProgress: PairingProgress

    private let matchDemographicsLabel = UILabel()
    private let matchNameLabel = UILabel()
    private let matchProfileImageView = UIImageView()
    private let matchSummaryTableView = UITableView()

    private var reachOutButton: UIButton?
    private var meetupStatusView: MeetupStatusView?

    private let imageSize = CGSize(width: 120, height: 120)
    private let reachOutButtonSize = CGSize(width: 200, height: 50)

    private var matchSummaries: [MatchSummary] = [
        // TODO: Remove after connecting to backend. These are temp values.
        MatchSummary(title: "You both love...", detail: "design and tech"),
        MatchSummary(title: "You're both part of...", detail: "AppDev"),
        MatchSummary(title: "He also enjoys...", detail: "music, reading, and business"),
        MatchSummary(title: "He is also part of...", detail: "EzraBox")
    ]

    init(for progress: PairingProgress) {
        pairingProgress = progress
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.navigationBar.isHidden = true TODO might not need this with the changes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .backgroundLightGreen

        // TODO: Remove after connecting to backend. These are temp values.
        let firstName = "Ezra"
        let lastName = "Cornell"
        let major = "Government"
        let year = 2020
        let hometown = "Ithaca, NY"

        if pairingProgress == .reachingOut || pairingProgress == .responding {
            reachOutButton = UIButton()
            if let reachOutButton = reachOutButton {
                reachOutButton.backgroundColor = .backgroundOrange
                reachOutButton.setTitleColor(.white, for: .normal)
                reachOutButton.layer.cornerRadius = reachOutButtonSize.height/2
                reachOutButton.titleLabel?.font = ._20CircularStdBold
                if pairingProgress == .reachingOut {
                    reachOutButton.setTitle("Reach out!", for: .normal)
                } else if pairingProgress == .responding {
                    reachOutButton.setTitle("Pick a time", for: .normal)
                }
                reachOutButton.addTarget(self, action: #selector(reachOutPressed), for: .touchUpInside)
                view.addSubview(reachOutButton)
            }
        }

        switch pairingProgress {
        case .waitingOnResponse:
            meetupStatusView = MeetupStatusView(reachedOutTo: firstName)
        case .responding:
            meetupStatusView = MeetupStatusView(respondingTo: firstName)
        case .dateScheduled:
            meetupStatusView = MeetupStatusView(chatScheduledOn: Date())
        default: break
        }
        if let meetupStatusView = meetupStatusView {
            view.addSubview(meetupStatusView)
        }

        matchDemographicsLabel.text = "\(major) \(year)\nFrom \(hometown)"
        matchDemographicsLabel.textColor = .textGreen
        matchDemographicsLabel.font = ._16CircularStdBook
        matchDemographicsLabel.numberOfLines = 0
        view.addSubview(matchDemographicsLabel)
        // TODO add back pronouns

        matchNameLabel.text = "\(firstName)\n\(lastName)"
        matchNameLabel.textColor = .textBlack
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
    }

    private func setupConstraints() {
        let padding: CGFloat = 35 // TODO: Not sure about dimensions.
        let reachOutPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 70) // TODO: Not sure about dimensions.
        let logoutPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 30) // TODO: Not sure about dimensions.
        let meetupPadding = 24
        let meetupSize = CGSize(width: 319, height: 75)
        let matchSummaryBottomPadding = 46

        meetupStatusView?.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(meetupPadding)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(meetupPadding)
            make.size.equalTo(meetupSize)
        }

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
            if let meetupStatusView = meetupStatusView {
                make.top.equalTo(meetupStatusView.snp.bottom).offset(padding)
            } else {
                make.top.equalToSuperview().offset(padding)
            }
            make.size.equalTo(imageSize)
        }

        matchSummaryTableView.snp.makeConstraints { make in
            make.top.equalTo(matchDemographicsLabel.snp.bottom).offset(padding)
            if let reachOutButton = reachOutButton {
                make.bottom.equalTo(reachOutButton.snp.top).offset(-padding)
            } else {
                make.bottom.equalToSuperview().inset(padding)
            }
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        reachOutButton?.snp.makeConstraints { make in
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

