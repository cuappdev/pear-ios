//
//  MatchProfileViewController.swift
//  Pear
//
//  Created by Lucy Xu on 4/28/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import GoogleSignIn
import Kingfisher
import UIKit

class MatchProfileViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private var chatStatus: ChatStatus?
    private let match: MatchV2?
    private var meetupStatusView: MeetupStatusView?
    private var profileSections = [ProfileSectionType]()
    private let profileTableView = UITableView(frame: .zero, style: .plain)
    private var reachOutButton = UIButton()
    private let user: UserV2?

    // MARK: - Private Data Vars
    private let reachOutButtonSize = CGSize(width: 200, height: 50)

    init(match: MatchV2?, user: UserV2?) {
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

        guard let match = match else { return }

//            if let match = self.match {
//                self.chatStatus = ChatStatus.forMatch(match: match, match: match)
//            }

        setupViews(match: match)
        setupConstraints()

        profileSections = [.summary, .basics]
//        if match.interests.count > 0 {
//            profileSections.append(.interests)
//        }
//        if match.groups.count > 0 {
//            profileSections.append(.groups)
//        }
        profileTableView.reloadData()

    }

    private func setupViews(match: MatchV2) {
        if let chatStatus = chatStatus {
            meetupStatusView = MeetupStatusView(for: chatStatus)
        }

        if let meetupStatusView = meetupStatusView {
            view.addSubview(meetupStatusView)
        }

        profileTableView.dataSource = self
        profileTableView.backgroundColor = .clear
        profileTableView.register(ProfileSummaryTableViewCell.self, forCellReuseIdentifier: ProfileSummaryTableViewCell.reuseIdentifier)
//        profileTableView.register(ProfileSectionTableViewCell.self, forCellReuseIdentifier: ProfileSectionTableViewCell.reuseIdentifier)
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
        case .planning, .noResponses:
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
//        guard let match = match, let match = match, let user = user else { return }
//        switch chatStatus {
//        case .planning, .noResponses:
//            navigationController?.pushViewController(SchedulingTimeViewController(for: .confirming, user: user, match: match, match: match), animated: true)
//        case .responding:
//            navigationController?.pushViewController(SchedulingTimeViewController(for: .choosing, user: user, match: match, match: match), animated: true)
//        default:
//            let emailAlertController = UIAlertController.getEmailAlertController(
//                email: "\(match.netID)@cornell.edu",
//                subject: "Hello from Pear!"
//            )
//            present(emailAlertController, animated: true)
//        }
    }

    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }

}

extension MatchProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let match = match else { return UITableViewCell() }
        let section = profileSections[indexPath.row]
        let reuseIdentifier = section.reuseIdentifier
        switch section {
        case .summary:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSummaryTableViewCell else { return UITableViewCell() }
            cell.configure(for: match.matchedUser)
            return cell
//        case .basics:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfilePromptTableViewCell else { return UITableViewCell() }
//            cell.configure(for: match.matchedUser, type: section)
//            return cell
//        case .interests, .groups:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSectionTableViewCell else { return UITableViewCell() }
//            cell.configure(for: match, type: section)
//            return cell
        default:
            return UITableViewCell()
        }
    }

}

extension MatchProfileViewController: UIGestureRecognizerDelegate {

      func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
         if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
             navigationController?.popViewController(animated: true)
         }
         return false
     }

  }
