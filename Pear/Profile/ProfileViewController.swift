//
//  ProfileViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//
import GoogleSignIn
import Kingfisher
import UIKit

enum ProfileType {
    case match, user
}

class ProfileViewController: UIViewController {

    private let backButton = UIButton()
    private var chatStatus: ChatStatus?
    private let match: Match?
    private var pair: User?
    private var profileSections = [ProfileSectionType]()
    private var type: ProfileType
    private let user: User?

    private var userId: String?

    private var meetupStatusView: MeetupStatusView?
    private let profileTableView = UITableView(frame: .zero, style: .plain)
    private var reachOutButton = UIButton()

    private let imageSize = CGSize(width: 120, height: 120)
    private let reachOutButtonSize = CGSize(width: 200, height: 50)

    private var matchSummaries: [MatchSummary] = []

    init(match: Match?, user: User?, userId: String?, type: ProfileType) {
        self.match = match
        self.user = user
        self.type = type
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == .match {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        if type == .user {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        let userFunctionThen = type == .user ? getUserThen : getPairThen

        if type == .user {
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.barTintColor = .backgroundLightGreen
            navigationController?.navigationBar.shadowImage = UIImage() // Hide navigation bar bottom shadow
            navigationController?.navigationBar.titleTextAttributes = [
                .font: UIFont.getFont(.medium, size: 24)
            ]
            backButton.setImage(UIImage(named: "backArrow"), for: .normal)
            backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }

        userFunctionThen { [weak self] pair in
            guard let self = self else { return }

            self.pair = pair

            if let match = self.match, self.type == .match {
                self.chatStatus = ChatStatus.forMatch(match: match, pair: pair)
            }

            self.setupViews(pair: pair)
            self.setupConstraints()

            self.profileSections = [.summary, .basics]
            if pair.interests.count > 0 {
                self.profileSections.append(.interests)
            }
            if pair.groups.count > 0 {
                self.profileSections.append(.groups)
            }
            self.profileTableView.reloadData()
        }
    }

    private func getPairThen(_ completion: @escaping (User) -> Void) {
        guard let match = match, let pairNetId = match.pair else {
            print("Unable to get the pair's netid from the match.")
            return
        }

        NetworkManager.shared.getUser(netId: pairNetId).observe { response in
            DispatchQueue.main.async {
                switch response {
                case .value(let result):
                    guard result.success else {
                        print("Network error: could not get user's pair.")
                        return
                    }
                    completion(result.data)
                case .error:
                    print("Network error: could not get user's pair.")
                }
            }
        }
    }

    private func getUserThen(_ completion: @escaping (User) -> Void) {
        guard let userId = userId else { return }
        NetworkManager.shared.getUser(netId: userId).observe { result in
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        completion(response.data)
                    }
                case .error:
                    print("Network error: could not get user.")
                }
            }
        }
    }

    private func setupViews(pair: User) {
        if let chatStatus = chatStatus {
            meetupStatusView = MeetupStatusView(for: chatStatus)
        }

        if let meetupStatusView = meetupStatusView {
            view.addSubview(meetupStatusView)
        }

        profileTableView.dataSource = self
        profileTableView.backgroundColor = .clear
        profileTableView.register(ProfileSummaryTableViewCell.self, forCellReuseIdentifier: ProfileSummaryTableViewCell.reuseIdentifier)
        profileTableView.register(ProfileSectionTableViewCell.self, forCellReuseIdentifier: ProfileSectionTableViewCell.reuseIdentifier)
        profileTableView.register(ProfilePromptTableViewCell.self, forCellReuseIdentifier: ProfilePromptTableViewCell.reuseIdentifier)
        profileTableView.rowHeight = UITableView.automaticDimension
        profileTableView.bounces = true
        profileTableView.separatorStyle = .none
        profileTableView.estimatedSectionHeaderHeight = 0
        profileTableView.sectionHeaderHeight = UITableView.automaticDimension
        profileTableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 150, right: 0)
        profileTableView.showsVerticalScrollIndicator = false
        view.addSubview(profileTableView)

        reachOutButton.backgroundColor = .backgroundOrange
        reachOutButton.layer.cornerRadius = reachOutButtonSize.height / 2
        reachOutButton.titleLabel?.font = ._20CircularStdBold
        reachOutButton.setTitleColor(.white, for: .normal)
        reachOutButton.addTarget(self, action: #selector(reachOutPressed), for: .touchUpInside)

        switch chatStatus {
        case .planning:
            reachOutButton.setTitle("Reach out", for: .normal)
        case .responding:
            reachOutButton.setTitle("Pick a time", for: .normal)
        default:
            reachOutButton.setTitle("Send email", for: .normal)
        }

        view.addSubview(reachOutButton)
    }

    private func setupConstraints() {
        let reachOutPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 70)
        let meetupPadding = 24
        let meetupWidth: CGFloat = 319

        meetupStatusView?.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(meetupPadding)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(meetupPadding)
            make.width.equalTo(meetupWidth)
            make.height.equalTo(meetupStatusView?.getRecommendedHeight(for: meetupWidth) ?? 0)
        }

        if let meetupStatusView = meetupStatusView {
            profileTableView.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(meetupStatusView.snp.bottom).offset(8)
            }
        } else {
            profileTableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        reachOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(reachOutPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(reachOutButtonSize)
        }
    }

    @objc private func reachOutPressed() {
        switch type {
        case .match:
            guard let pair = pair, let match = match, let user = user else { return }
            let schedulingVC: SchedulingTimeViewController

            switch chatStatus {
            case .planning, .noResponses:
                schedulingVC = SchedulingTimeViewController(for: .confirming, user: user, pair: pair, match: match)
                navigationController?.pushViewController(schedulingVC, animated: true)
            case .responding:
                print("this is my match", match)
                schedulingVC = SchedulingTimeViewController(for: .choosing, user: user, pair: pair, match: match)
                navigationController?.pushViewController(schedulingVC, animated: true)
            default:
                URLScheme.openGmail(to: "\(pair.netID)@cornell.edu", subject: "Hello from Pear!")
            }
        case .user:
            guard let pair = pair else { return }
            URLScheme.openGmail(to: "\(pair.netID)@cornell.edu", subject: "Hello from Pear!")
        }
    }

    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }

}

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pair = pair else { return UITableViewCell() }
        let section = profileSections[indexPath.row]
        let reuseIdentifier = section.reuseIdentifier

        switch section {
        case .summary:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSummaryTableViewCell else { return UITableViewCell() }
            cell.configure(for: pair)
            return cell
        case .basics:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfilePromptTableViewCell else { return UITableViewCell() }
            cell.configure(for: pair, type: section)
            return cell
        case .interests, .groups:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSectionTableViewCell else { return UITableViewCell() }
            cell.configure(for: pair, type: section)
            return cell
        case .matches:
            return UITableViewCell()
        }
    }

}

extension ProfileViewController: UIGestureRecognizerDelegate {

      func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
         if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
             navigationController?.popViewController(animated: true)
         }
         return false
     }
    
  }
