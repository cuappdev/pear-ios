//
//  MatchViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//
import GoogleSignIn
import Kingfisher
import UIKit

/// If the local stored matchID matches the current match from backend, then the user has already reached out
private func userAlreadyReachedOut(to match: Match) -> Bool {
    let matchIDLastReachedOut = UserDefaults.standard.string(forKey: Constants.UserDefaults.matchIDLastReachedOut)
    return matchIDLastReachedOut == match.matchID
}

enum ChatStatus {
    /// No one has reached out yet
    case planning
    /// No one has reached out in 3 days
    case noResponses

    /// User already reached out and is waiting on `SubUser`
    case waitingOn(User)
    /// `SubUser` already reached out, and user is responding
    case respondingTo(User)

    /// The chat date has passed
    case finished
    /// The chat has been cancelled with `SubUser`
    case cancelled(User)

    /// Chat between the User and `SubUser` has been scheduled and is coming up on `Date`
    case chatScheduled(User, Date)

    static func forMatch(match: Match, pair: User) -> ChatStatus {
        if match.allAvailibilitiesPassed {
            return .finished
        }

        switch match.status {
        case Constants.Match.created:
            return Time.daysSinceMatching >= 3 ? .noResponses : .planning

        case Constants.Match.proposed:
            return userAlreadyReachedOut(to: match) ? .waitingOn(pair) : .respondingTo(pair)

        case Constants.Match.cancelled:
            return .cancelled(pair)

        case Constants.Match.active:
            guard let availability = match.availabilities.first else {
                print("match's timeAvailability has no availabilities, but is active. Returning finished instead")
                return .finished
            }
            guard let date = Time.next(day: availability.day, times: availability.times) else {
                print("Couldn't convert match's timeAvailability to a Date, returning finished instead")
                return .finished
            }
            return Time.scheduleHasPassed(day: availability.day, times: availability.times)
                ? .finished
                : .chatScheduled(pair, date)

        case Constants.Match.inactive:
            return .finished

        default:
            print("Match has an invalid status; Using planning instead (match: \(match))")
            return .planning
        }
    }

}

class MatchViewController: UIViewController {

    private let match: Match
    private let user: User
    private var pair: User?
    private var chatStatus: ChatStatus?

    private let matchClassLabel = UILabel()
    private let matchNameLabel = UILabel()
    private let matchHometownLabel = UILabel()
    private let matchNetIdLabel = UILabel()
    private let matchProfileBackgroundView = UIStackView()
    private let matchProfileImageView = UIImageView()
    private let matchPronounsLabel = UILabel()
    private let matchSummaryTableView = UITableView()
    private var meetupStatusView: MeetupStatusView?
    private var reachOutButton = UIButton()

    private let imageSize = CGSize(width: 120, height: 120)
    private let reachOutButtonSize = CGSize(width: 200, height: 50)

    private var shouldShowReachOutButton: Bool {
        switch chatStatus {
        case .finished, .cancelled:
            return false
        default:
            return !userAlreadyReachedOut(to: self.match)
        }
    }

    private var matchSummaries: [MatchSummary] = []

    init(match: Match, user: User) {
        self.match = match
        self.user = user
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
        view.backgroundColor = .backgroundLightGreen

        getPairThen { [weak self] pair in
            guard let self = self else { return }

            self.pair = pair
            self.chatStatus = ChatStatus.forMatch(match: self.match, pair: pair)

            self.setupMatchSummaries()
            self.setupViews(pair: pair)
            self.setupConstraints()
        }
    }

    private func getPairThen(_ closure: @escaping (User) -> Void) {
        guard let pairNetId = match.pair else {
            print("Unable to get the pair's netid from the match.")
            return
        }

        NetworkManager.shared.getUser(netId: pairNetId).observe { response in
            switch response {
            case .value(let result):
                guard result.success else {
                    print("Network error: could not get user's pair.")
                    return
                }
                DispatchQueue.main.async {
                    closure(result.data)
                }
            case .error:
                print("Network error: could not get user's pair.")
            }
        }
    }

    private func setupViews(pair: User) {
        if shouldShowReachOutButton {
            reachOutButton = UIButton()
            reachOutButton.backgroundColor = .backgroundOrange
            reachOutButton.layer.cornerRadius = reachOutButtonSize.height / 2
            reachOutButton.titleLabel?.font = ._20CircularStdBold
            reachOutButton.setTitleColor(.white, for: .normal)
            reachOutButton.addTarget(self, action: #selector(reachOutPressed), for: .touchUpInside)

            switch chatStatus {
            case .planning, .noResponses:
                reachOutButton.setTitle("Reach out", for: .normal)
            case .respondingTo:
                reachOutButton.setTitle("Pick a time", for: .normal)
            default:
                reachOutButton.setTitle("Enter availability", for: .normal)
            }
            view.addSubview(reachOutButton)
        }

        if let chatStatus = chatStatus {
            meetupStatusView = MeetupStatusView(for: chatStatus)
        }
        if let meetupStatusView = meetupStatusView {
            view.addSubview(meetupStatusView)
        }

        matchProfileBackgroundView.axis = .vertical
        matchProfileBackgroundView.spacing = 4
        view.addSubview(matchProfileBackgroundView)

        matchNameLabel.text = "\(pair.firstName) \(pair.lastName)"
        matchNameLabel.textColor = .black
        matchNameLabel.numberOfLines = 0
        matchNameLabel.font = ._24CircularStdMedium
        matchProfileBackgroundView.insertArrangedSubview(matchNameLabel, at: 0)
        
        matchNetIdLabel.text = "NetID: \(pair.netID)"
        matchNetIdLabel.textColor = .textGreen
        matchNetIdLabel.font = ._16CircularStdBook
        matchNetIdLabel.numberOfLines = 0
        matchProfileBackgroundView.insertArrangedSubview(matchNetIdLabel, at: 1)
        
        let graduationYear = String(pair.graduationYear?.suffix(2) ?? "")
        matchClassLabel.text = "\(pair.major) '\(graduationYear)"
        matchClassLabel.textColor = .textGreen
        matchClassLabel.font = ._16CircularStdBook
        matchClassLabel.numberOfLines = 0
        matchProfileBackgroundView.insertArrangedSubview(matchClassLabel, at: 2)
        
        matchHometownLabel.text = "from \(pair.hometown)"
        matchHometownLabel.textColor = .textGreen
        matchHometownLabel.font = ._16CircularStdBook
        matchHometownLabel.numberOfLines = 0
        matchProfileBackgroundView.insertArrangedSubview(matchHometownLabel, at: 3)
        
        matchPronounsLabel.text = pair.pronouns
        matchPronounsLabel.textColor = .textGreen
        matchPronounsLabel.font = ._16CircularStdBook
        matchPronounsLabel.numberOfLines = 0
        matchProfileBackgroundView.insertArrangedSubview(matchPronounsLabel, at: 4)

        matchProfileImageView.backgroundColor = .inactiveGreen
        matchProfileImageView.layer.cornerRadius = imageSize.width/2
        matchProfileImageView.layer.masksToBounds = true
        matchProfileImageView.contentMode = .scaleAspectFill
        matchProfileImageView.clipsToBounds = true
        matchProfileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: pair.profilePictureURL, cacheKey: pair.googleID))
   
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
            if shouldShowReachOutButton {
                make.bottom.equalTo(reachOutButton.snp.top).offset(-padding)
            } else {
                make.bottom.equalToSuperview().inset(padding)
            }
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        if shouldShowReachOutButton {
            reachOutButton.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(reachOutPadding)
                make.centerX.equalToSuperview()
                make.size.equalTo(reachOutButtonSize)
            }
        }
    }

    private func setupMatchSummaries() {
        guard let pair = pair else { return }

        var pronoun: String
        if pair.pronouns == "She/Her/Hers" {
            pronoun = "She"
        } else if pair.pronouns == "He/Him/His" {
            pronoun = "He"
        } else {
            pronoun = "They"
        }
        let commonInterests = user.interests.filter { pair.interests.contains($0) }
        let commonGroups = user.groups.filter { pair.groups.contains($0) }
        let uncommonInterests = pair.interests.filter { !commonInterests.contains($0) }
        let uncommonGroups = pair.groups.filter { !commonGroups.contains($0) }

        addMatchSummary(
          title: "You both love...",
          items: commonInterests
        )
        addMatchSummary(
          title: "You're both part of...",
          items: commonGroups
        )
        addMatchSummary(
          title: "\(pronoun) also enjoys...",
          items: uncommonInterests
        )
        addMatchSummary(
          title: "\(pronoun) is also part of...",
          items: uncommonGroups
        )
    }

    private func addMatchSummary(title: String, items: [String]) {
        if items.count > 0 {
            let matchSummary = MatchSummary(title: title, detail: stringListToSentence(words: items))
            matchSummaries.append(matchSummary)
        }
    }

    /// Converts `words` to a sentence based on the number of words
    private func stringListToSentence(words: [String]) -> String {
        switch words.count {
        case 1:
            return words[0]
        case 2:
            return "\(words[0]) and \(words[1])"
        case let x where x >= 3:
            return "\(words[0]), \(words[1]) and \(words[2])"
        default:
            return ""
        }
    }

    @objc private func reachOutPressed() {
        guard let pair = pair else { return }
        let schedulingVC: SchedulingTimeViewController

        switch chatStatus {
        case .planning, .noResponses:
            schedulingVC = SchedulingTimeViewController(for: .confirming, user: user, pair: pair, match: match)
        case .waitingOn, .respondingTo:
            schedulingVC = SchedulingTimeViewController(for: .choosing, user: user, pair: pair, match: match)
        default:
            print("Creating a SchedulingTimeViewController for a ChatStatus that shouldn't schedule times; will show pickingTypical instead")
            schedulingVC = SchedulingTimeViewController(for: .pickingTypical, user: user)
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
