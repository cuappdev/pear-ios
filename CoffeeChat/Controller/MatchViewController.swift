//
//  MatchViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import GoogleSignIn
import UIKit

enum ChatStatus {
    /// No one has reached out yet
    case planning
    /// No one has reached out in 3 days
    case noResponses

    /// User already reached out and is waiting on pair
    case waitingOn(SubUser)
    /// Pair already reached out, and user is responding
    case respondingTo(SubUser)

    /// The chat date has passed
    case finished
    /// The chat has been cancelled
    case cancelled(SubUser)

    /// Chat has been scheduled and is coming up
    case chatScheduled(SubUser, Date)

    // TODO change when matching responses change
    static func forMatching(matching: Matching) -> ChatStatus {
        let matchDaySchedule = matching.schedule.first
        let matchPear = matching.users[1]
        if let matchDaySchedule = matchDaySchedule, matching.active {
            if matching.schedule.first!.hasPassed() {
                // finished date passed: finished
                return .finished
            } else {
                // coming up: chatScheduled
                return .chatScheduled(matchPear, matchDaySchedule.getDate())
            }
            // TODO can't differntiate yet: cancelled
            return .cancelled(matchPear)
        } else {
            if let matchDaySchedule = matchDaySchedule {
                // TODO can't distinguish who started it so
                // If user already reached out: waitingOn
                // If user has to reach: respondingTo

                return respondingTo(matchPear)
                //return waitingOn(matchPear)
            } else { // nobody started the flow
                // if its been 3 days since the match began (3 days after sunday, so wednesday): noResponses
                if Time.daysSinceMatching > 3 {
                    return .noResponses
                } else {
                    // Show no banner: planned
                    return .planning
                }

            }
        }
    }

}

class MatchViewController: UIViewController {

    private let matching: Matching
    private let chatStatus: ChatStatus
    private var hasReachedOut: Bool {
        get {
            switch chatStatus {
            case .chatScheduled, .waitingOn, .finished, .cancelled:
                return true
            default:
                return false
            }
        }
    }

    private let matchDemographicsLabel = UILabel()
    private let matchNameLabel = UILabel()
    private let matchProfileBackgroundView = UIStackView()
    private let matchProfileImageView = UIImageView()
    private let matchSummaryTableView = UITableView()
    private var meetupStatusView: MeetupStatusView?
    private var reachOutButton = UIButton()

    private let imageSize = CGSize(width: 120, height: 120)
    private let reachOutButtonSize = CGSize(width: 200, height: 50)

    private var matchSummaries: [MatchSummary] = [
        // TODO: Remove after connecting to backend. These are temp values.
        MatchSummary(title: "You both love...", detail: "design and tech"),
        MatchSummary(title: "You're both part of...", detail: "AppDev"),
        MatchSummary(title: "He also enjoys...", detail: "music, reading, and business"),
        MatchSummary(title: "He is also part of...", detail: "EzraBox")
    ]

    init(matching: Matching) {
        self.matching = matching
        print("Matching: \(matching)")
        self.chatStatus = ChatStatus.forMatching(matching: matching)
        print("Chat Status: \(self.chatStatus)")
        print("Days since the matching: \(Time.daysSinceMatching)")
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        let user = User(clubs: [],
                        firstName: firstName,
                        googleID: "",
                        graduationYear: "2020",
                        hometown: hometown,
                        interests: [],
                        lastName: lastName,
                        major: major,
                        matches: [],
                        netID: "",
                        profilePictureURL: "",
                        pronouns: "pronouns",
                        facebook: "https://www.facebook.com",
                        instagram: "https://www.instagram.com")

        reachOutButton = UIButton()
        reachOutButton.backgroundColor = .backgroundOrange
        reachOutButton.setTitleColor(.white, for: .normal)
        reachOutButton.layer.cornerRadius = reachOutButtonSize.height/2
        reachOutButton.titleLabel?.font = ._20CircularStdBold
        reachOutButton.setTitle("Pick a time", for: .normal) // TODO change text based on whether responding
        reachOutButton.addTarget(self, action: #selector(reachOutPressed), for: .touchUpInside)
        if !hasReachedOut {
            view.addSubview(reachOutButton)
        }

        switch chatStatus {
        case .noResponses, .waitingOn, .respondingTo, .finished, .cancelled, .chatScheduled:
            meetupStatusView = MeetupStatusView(for: chatStatus)
        default:
            break
        }
        if let meetupStatusView = meetupStatusView {
            view.addSubview(meetupStatusView)
        }

        matchProfileBackgroundView.axis = .vertical
        matchProfileBackgroundView.spacing = 4
        view.addSubview(matchProfileBackgroundView)

        matchNameLabel.text = "\(firstName)\n\(lastName)"
        matchNameLabel.textColor = .black
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
        matchSummaryTableView.register(MatchSummaryTableViewCell.self,
                                       forCellReuseIdentifier: MatchSummaryTableViewCell.reuseIdentifier)
        view.addSubview(matchSummaryTableView)
    }

    private func setupConstraints() {
        let padding = 35
        let reachOutPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 70)
        let meetupPadding = 24
        let meetupWidth: CGFloat = 319

        meetupStatusView?.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(meetupPadding)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(meetupPadding)
            make.width.equalTo(meetupWidth)
            make.height.equalTo(meetupStatusView?.getRecommendedHeight(for: meetupWidth) ?? 0)
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
            if !hasReachedOut {
                make.bottom.equalTo(reachOutButton.snp.top).offset(-padding)
            } else {
                make.bottom.equalToSuperview().inset(padding)
            }
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        if !hasReachedOut {
            reachOutButton.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(reachOutPadding)
                make.centerX.equalToSuperview()
                make.size.equalTo(reachOutButtonSize)
            }
        }

    }

    @objc private func reachOutPressed() {
        let timeVC = SchedulingTimeViewController(for: .confirming)
        navigationController?.pushViewController(timeVC, animated: true)
    }
}

extension MatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchSummaries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchSummaryTableViewCell.reuseIdentifier,
                                                       for: indexPath) as?
                MatchSummaryTableViewCell else { return UITableViewCell() }
        let summary = matchSummaries[indexPath.row]
        cell.configure(for: summary)
        return cell
    }

}
