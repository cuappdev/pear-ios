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
    case chatScheduled
    case afterChat
    case cancelled
}

class MatchViewController: UIViewController {

    private let pairingProgress: PairingProgress

    private let matchDemographicsLabel = UILabel()
    private let matchProfileBackgroundView = UIStackView()
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
        let pronouns = "He/Him"
        let hometown = "Ithaca, NY"
        let user = User(clubs: [], firstName: firstName, googleID: "", graduationYear: "2020", hometown: hometown,
                        interests: [], lastName: lastName, major: major, matches: [], netID: "", profilePictureURL: "",
                        pronouns: "pronouns", facebook: "https://www.facebook.com", instagram: "https://www.instagram.com")

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
            meetupStatusView = MeetupStatusView(for: .waitingOn(user))
        case .responding:
            meetupStatusView = MeetupStatusView(for: .respondingTo(user))
        case .chatScheduled:
            meetupStatusView = MeetupStatusView(for: .chatScheduled(user, Date()))
        default: break
        }
        if let meetupStatusView = meetupStatusView {
            view.addSubview(meetupStatusView)
        }

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
        matchSummaryTableView.isScrollEnabled = false
        matchSummaryTableView.dataSource = self
        matchSummaryTableView.register(MatchSummaryTableViewCell.self, forCellReuseIdentifier: MatchSummaryTableViewCell.reuseIdentifier)
        view.addSubview(matchSummaryTableView)
    }

    private func setupConstraints() {
        let padding: CGFloat = 35
        let reachOutPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 70)
        let logoutPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 30)
        let meetupPadding = 24
        let meetupWidth: CGFloat = 319
        let matchSummaryBottomPadding = 46

        print(meetupStatusView!.getRecommendedHeight(for: meetupWidth))
        meetupStatusView?.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(meetupPadding)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(meetupPadding)
            make.width.equalTo(meetupWidth)
            make.height.equalTo(meetupStatusView!.getRecommendedHeight(for: meetupWidth))
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

        matchProfileBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(matchProfileImageView)
            make.leading.equalTo(matchProfileImageView.snp.trailing).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        matchSummaryTableView.snp.makeConstraints { make in
            make.top.equalTo(matchProfileBackgroundView.snp.bottom).offset(padding)
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

