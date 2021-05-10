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
    private var chatBubble = UIView()
    private var chatMessage = UILabel()
    private var pairProfilePic = UIImageView()

    // MARK: - Private Data Vars
    static let reuseId = "chatReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .backgroundLightGreen

        chatBubble.layer.cornerRadius = 16
        chatBubble.backgroundColor = .red
        chatBubble.clipsToBounds = true
        contentView.addSubview(chatBubble)

        chatMessage.font = ._16CircularStdBook
        chatMessage.numberOfLines = 0
        chatMessage.textColor = .black
        chatBubble.addSubview(chatMessage)

        pairProfilePic.contentMode = .scaleAspectFill
        pairProfilePic.layer.cornerRadius = 21
        pairProfilePic.clipsToBounds = true
        contentView.addSubview(pairProfilePic)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints(message: PearMessage, currentUserNetID: String) {

        let messagePadding: CGFloat = 5
        let rightMessagePadding: CGFloat = -15
        let leftMessagePadding: CGFloat = 7

        chatBubble.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(messagePadding)
            make.bottom.equalTo(contentView.snp.bottom).offset(-messagePadding)
            if message.senderNetID == currentUserNetID {
                make.trailing.equalTo(contentView.snp.trailing).offset(rightMessagePadding)
                make.width.lessThanOrEqualTo(250)
            } else {
                make.leading.equalTo(pairProfilePic.snp.trailing).offset(leftMessagePadding)
                make.width.lessThanOrEqualTo(210)
            }
        }

        chatMessage.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(messagePadding*2)
        }

        pairProfilePic.snp.makeConstraints { make in
            make.bottom.equalTo(chatBubble.snp.bottom).offset(-3)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.width.height.equalTo(42)
        }

    }

    func configure(for message: PearMessage, user: User, pair: MessageUser) {
        chatMessage.text = message.message
        if message.senderNetID == user.netID {
            chatBubble.backgroundColor = .pearGreen
            chatMessage.textColor = .white
            pairProfilePic.isHidden = true
        }
        else {
            chatBubble.backgroundColor = .paleGreen
            chatMessage.textColor = .black
            pairProfilePic.isHidden = false
            pairProfilePic.kf.setImage(with: URL(string: pair.profilePictureURL))
        }
        setupConstraints(message: message, currentUserNetID: user.netID)
    }

}
