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
    private var match: MatchedUser?
    private var meetupStatusView: MeetupStatusView?
    private var profileSections = [ProfileSectionType]()
    private let profileTableView = UITableView(frame: .zero, style: .plain)
    private let user: UserV2

    init(user: UserV2) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        getCurrentMatch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
//            if let match = self.match {
//                self.chatStatus = ChatStatus.forMatch(match: match, match: match)
//            }
    }

    private func setupViews(match: MatchV2) {
//        if let chatStatus = chatStatus {
//            meetupStatusView = MeetupStatusView(for: chatStatus)
//        }

//        if let meetupStatusView = meetupStatusView {
//            view.addSubview(meetupStatusView)
//        }

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

        profileSections = [.summary, .basics]
//        if match.matchedUser.interests.count > 0 {
//            profileSections.append(.interests)
//        }
//        if match.matchedUser.groups.count > 0 {
//            profileSections.append(.groups)
//        }

        profileTableView.reloadData()

        setupConstraints()
    }

    private func setupConstraints() {
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
    }

    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    func getCurrentMatch() {
        NetworkManager.getCurrentMatch { [weak self] match in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.match = match.matchedUser
                self.setupViews(match: match)
            }
        }
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
            cell.configure(for: match)
            return cell
        case .basics:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfilePromptTableViewCell else { return UITableViewCell() }
            cell.configure(for: match, type: section)
            return cell
        case .interests, .groups:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileSectionTableViewCell else { return UITableViewCell() }
            cell.configure(for: match, type: section)
            return cell
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
