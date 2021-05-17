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
    private var messageUsers: [MessageUser] = []
    private var timer: Timer?
    private var user: User

    init(user: User) {
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
        getMessageMatches(netId: user.netID) { matches in
            for match in matches {
                guard let pairNetId = match.pair  else {
                    print("Unable to get the pair's netid from the match.")
                    return
                }
                self.getMessageUserData(pairNetId: pairNetId) { pair in
                    let messageUser = MessageUser(
                        netID: pair.netID,
                        firstName: pair.firstName,
                        lastName: pair.lastName,
                        status: match.status,
                        meetingTime: match.meetingTime,
                        profilePictureURL: pair.profilePictureURL ?? ""
                    )
                    self.messageUsers.append(messageUser)
                    self.reloadMessagesTableView()
                }
            }
        }
    }

    private func reloadMessagesTableView() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { timer in
            // TODO - sort by time when timestamps added to backend
            DispatchQueue.main.async {
                self.messagesTableView.reloadData()
            }
        })
    }

    private func getMessageMatches(netId: String, completion: @escaping ([Match]) -> Void) {
        NetworkManager.shared.getMatchHistory(netID: netId).observe { result in
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    guard response.success else {
                        print("Network error: could not get user match history")
                        return
                    }
                    completion(response.data)
                case .error:
                    print("Network error: could not get user match history")
                }
            }
        }
    }

    private func getMessageUserData(pairNetId: String, completion: @escaping (User) -> Void) {
        NetworkManager.shared.getUser(netId: pairNetId).observe { result in
            DispatchQueue.main.async {
                switch result {
                case .value(let result):
                    guard result.success else {
                        print("Network error: could not get user's pair.")
                        return
                    }
                    completion(result.data)
                case .error:
                    print("Network error: could not get the pair")
                }
            }
        }
    }

}

extension MessagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: MessagesTableViewCell.reuseId, for: indexPath) as? MessagesTableViewCell else { return UITableViewCell() }
        let messageUser = messageUsers[indexPath.row]
        cell.configure(for: messageUser)
        return cell
    }

}

extension MessagesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageUser = messageUsers[indexPath.row]
        navigationController?.pushViewController(ChatViewController(messageUser: messageUser, currentUser: user), animated: true)
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
