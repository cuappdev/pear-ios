//
//  ChatTableViewCell.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let chatBubble = UIView()
    private let chatMessage = UILabel()
    private let pairProfilePic = UIImageView()

    // MARK: - Private Data Vars
    static let reuseId = "chatReuseIdentifier"
    var viewProfile: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .backgroundLightGreen

        chatBubble.layer.cornerRadius = 16
        chatBubble.clipsToBounds = true
        contentView.addSubview(chatBubble)

        chatMessage.font = ._16CircularStdBook
        chatMessage.numberOfLines = 0
        chatMessage.textColor = .black
        chatBubble.addSubview(chatMessage)

        let photoTap = UITapGestureRecognizer()
        photoTap.addTarget(self, action: #selector(handleTapPhoto))

        pairProfilePic.contentMode = .scaleAspectFill
        pairProfilePic.layer.cornerRadius = 21
        pairProfilePic.clipsToBounds = true
        pairProfilePic.addGestureRecognizer(photoTap)
        pairProfilePic.isUserInteractionEnabled = true
        contentView.addSubview(pairProfilePic)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func handleTapPhoto() {
        if let viewProfile = viewProfile {
            viewProfile()
        }
    }

    private func setupConstraints(message: PearMessage, currentUserId: Int) {
        let messagePadding: CGFloat = 5

        chatBubble.snp.remakeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(messagePadding)
            if message.senderId == currentUserId {
                make.trailing.equalTo(contentView.snp.trailing).offset(-15)
                make.width.lessThanOrEqualTo(250)
            } else {
                make.leading.equalTo(pairProfilePic.snp.trailing).offset(7)
                make.width.lessThanOrEqualTo(230)
            }
        }
        chatMessage.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(messagePadding * 2)
        }
        pairProfilePic.snp.makeConstraints { make in
            make.bottom.equalTo(chatBubble).offset(-3)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.width.height.equalTo(42)
        }
    }

    func configure(for message: PearMessage, user: UserV2, pair: MatchedUser) {
        chatMessage.text = message.message
        if message.senderId == user.id {
            chatBubble.backgroundColor = .darkGreen
            chatMessage.textColor = .white
            pairProfilePic.isHidden = true
        } else {
            chatBubble.backgroundColor = .paleGreen
            chatMessage.textColor = .black
            pairProfilePic.isHidden = false
            pairProfilePic.kf.setImage(with: URL(string: pair.profilePicUrl ?? ""))
        }
        setupConstraints(message: message, currentUserId: user.id)
    }

}
