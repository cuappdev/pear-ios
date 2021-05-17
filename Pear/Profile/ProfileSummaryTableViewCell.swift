//
//  ProfileSummaryTableViewCell.swift
//  Pear
//
//  Created by Lucy Xu on 3/11/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class ProfileSummaryTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let messagingButton = UIButton()
    private let nameLabel = UILabel()
    private let profileImageView = UIImageView()

    // MARK: - Private Data Vars
    private let profileImageSize = CGSize(width: 150, height: 150)
    private var currentUser: User?
    private var pair: User?
    var showMessages: ((MessageUser, User) -> Void)?

    static let reuseIdentifier = "ProfileSummaryTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        profileImageView.backgroundColor = .greenGray
        profileImageView.layer.cornerRadius = profileImageSize.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        contentView.addSubview(profileImageView)

        nameLabel.font = ._24CircularStdMedium
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)

        messagingButton.setTitle("Message", for: .normal)
        messagingButton.layer.cornerRadius = 4
        messagingButton.backgroundColor = .white
        messagingButton.setTitleColor(.greenGray, for: .normal)
        messagingButton.titleLabel?.font = ._14CircularStdBook
        messagingButton.addTarget(self, action: #selector(presentMessaging), for: .touchUpInside)
        contentView.addSubview(messagingButton)

        setupConstraints()
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(profileImageSize)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }

        messagingButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(26)
            make.width.equalTo(73)
            make.bottom.equalToSuperview().inset(10)
        }

    }

    private func getMessageMatch(netId: String, completion: @escaping (Match) -> Void) {
        NetworkManager.shared.getMatchHistory(netID: netId).observe { result in
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    guard response.success else {
                        print("Network error: could not get user match history")
                        return
                    }
                    guard let match = response.data.filter{$0.status != "canceled" }.first else { return }
                    completion(match)
                case .error:
                    print("Network error: could not get user match history")
                }
            }
        }
    }

    private func getMessageUser(pairNetId: String, completion: @escaping (User) -> Void) {
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

    private func getUser(netId: String, completion: @escaping (User) -> Void) {
        NetworkManager.shared.getUser(netId: netId).observe { result in
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

    @objc func presentMessaging() {
        guard let currentUser = currentUser, let pair = pair else { return }
        let messageUser = MessageUser(
            netID: pair.netID,
            firstName: pair.firstName,
            lastName: pair.lastName,
            status: "created",
            meetingTime: nil,
            profilePictureURL: pair.profilePictureURL ?? ""
        )
        if let showMessages = self.showMessages {
            showMessages(messageUser, currentUser)
        }
    }

    func configure(for currentUser: User?, pair: User) {
        nameLabel.text = "\(pair.firstName) \(pair.lastName)"
        self.currentUser = currentUser
        self.pair = pair
        if let profilePictureURL = URL(string: pair.profilePictureURL ?? "") {
            profileImageView.kf.setImage(with: profilePictureURL)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
