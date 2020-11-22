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

    /// User already reached out and is waiting on `SubUser`
    case waitingOn(SubUser)
    /// `SubUser` already reached out, and user is responding
    case respondingTo(SubUser)

    /// The chat date has passed
    case finished
    /// The chat has been cancelled with `SubUser`
    case cancelled(SubUser)

    /// Chat between the User and `SubUser` has been scheduled and is coming up on `Date`
    case chatScheduled(SubUser, Date)

    // TODO change when matching responses change
    // The current Matching doesn't hold enough information to distinguish between all states, so this function will
    // change in the near future
    static func forMatching(matching: Matching) -> ChatStatus {
        guard matching.users.count > 1 else {
            print("Attempted to extract a pear for a matching with only 1 person: returning .planning as the ChatStatus")
            return .planning
        }
        let matchPear = matching.users[1]

        guard let matchDaySchedule = matching.schedule.first,
            let matchTime = matchDaySchedule.nextCorrespondingDate else {
            return Time.daysSinceMatching > 3 ? .noResponses : .planning
        }

        if matching.active {
            return matchDaySchedule.hasPassed
            ? .finished
            : .chatScheduled(matchPear, matchTime)
        } else {
            return respondingTo(matchPear)
        }
    }

}

class MatchViewController: UIViewController {

    private let pair: SubUser
    private let chatStatus: ChatStatus
    private var hasReachedOut: Bool {
        switch chatStatus {
        case .chatScheduled, .waitingOn, .finished, .cancelled:
            return true
        default:
            return false
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
        self.pair = matching.users[1]
        self.chatStatus = ChatStatus.forMatching(matching: matching)
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

        matchNameLabel.text = "\(pair.firstName)\n\(pair.lastName)"
        matchNameLabel.textColor = .black
        matchNameLabel.numberOfLines = 0
        matchNameLabel.font = ._24CircularStdMedium
        matchProfileBackgroundView.insertArrangedSubview(matchNameLabel, at: 0)

        let major = "???" // TODO update with info from User, not SubUser
        matchDemographicsLabel.text = "\(major) \(pair.graduationYear)\nFrom \(pair.hometown)\n\(pair.pronouns)"
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
        let schedulingVC: SchedulingTimeViewController
        switch chatStatus {
        case .planning, .noResponses:
            schedulingVC = SchedulingTimeViewController(for: .confirming)
        case .waitingOn, .respondingTo:
            schedulingVC = SchedulingTimeViewController(for: .choosing)
        default:
            print("Creating a SchedulingTimeViewController for a ChatStatus that shouldn't schedule times; will show pickingTypical instead")
            schedulingVC = SchedulingTimeViewController(for: .pickingTypical)
        }
        navigationController?.pushViewController(schedulingVC, animated: true)
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
