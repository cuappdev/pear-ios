//
//  MessagesViewController.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/2/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Firebase
import UIKit

class MessagesViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private var messagesTableView = UITableView()
    private let subtitleLabel = UILabel()

    // MARK: - Private Data Vars
    private let databaseRef = Database.database().reference()
    private var matchedUsers: [MatchedUser] = []
    private var matches: [TempMatchV2] = []
    private var timer: Timer?
    private var user: UserV2

    init(user: UserV2) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        title = "Past pears"

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(.medium, size: 24)
        ]

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.backButtonSize)
        }
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        subtitleLabel.text = "Keep in touch with each other :)"
        subtitleLabel.textColor = .greenGray
        subtitleLabel.font = ._12CircularStdBook
        view.addSubview(subtitleLabel)

        messagesTableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: MessagesTableViewCell.reuseId)
        messagesTableView.backgroundColor = .backgroundLightGreen
        messagesTableView.separatorStyle = .none
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        view.addSubview(messagesTableView)

        getUserMessages()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        Analytics.logEvent(Constants.Analytics.openedViewController, parameters: ["name" : Constants.Analytics.TrackedVCs.messages])
    }

    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func setupConstraints() {
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        messagesTableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func getUserMessages() {
        NetworkManager.getAllMatches { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let matches):
                DispatchQueue.main.async {
                    self.matches = matches
                    self.matchedUsers = matches.compactMap { $0.users.first(where: { $0.id != self.user.id }) }
                    self.reloadMessagesTableView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func reloadMessagesTableView() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { timer in
            DispatchQueue.main.async {
                self.messagesTableView.reloadData()
            }
        })
    }

}

extension MessagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchedUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: MessagesTableViewCell.reuseId, for: indexPath) as? MessagesTableViewCell else { return UITableViewCell() }
        let pair = matchedUsers[indexPath.row]
        let status = matches[indexPath.row].status
        cell.configure(for: pair, status: status, week: indexPath.row + 1)
        return cell
    }

}

extension MessagesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let match = matchedUsers[indexPath.row]
        let status = matches[indexPath.row].status
        navigationController?.pushViewController(ChatViewController(messageUser: match, currentUser: user, status: status), animated: true)
    }

}

extension MessagesViewController: UIGestureRecognizerDelegate {

      func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
         if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
             navigationController?.popViewController(animated: true)
         }
         return false
     }

}
