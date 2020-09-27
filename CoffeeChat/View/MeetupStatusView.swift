//
//  MeetupStatusView.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 9/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

enum MeetupState {
    case newPair, reachedOut, chatScheduled
}

class MeetupStatusView: UIView { // TODO improve naming probably


    private let backgroundShadingView = UIView()
    private let messageLabel = UILabel()
    private let pearImageView = UIImageView()
    private let statusImageView = UIImageView()
    private let statusLabel = UILabel()

    private let pearImageSize = CGSize(width: 40, height: 40)

    init(for state: MeetupState) {
        super.init(frame: .zero)

        //XXX DEBUG
        statusLabel.text = "status"
        messageLabel.text = "message label!"
        // ---------

        setupViews()
        setupConstraints()

        switch state {
        case .newPair:
            setupForNewPair()
        case .reachedOut:
            setupForNewPair()
        case .chatScheduled:
            setupForChatScheduled()
        }

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundShadingView.backgroundColor = .backgroundLightGrayGreen
        backgroundShadingView.layer.cornerRadius = 12
        addSubview(backgroundShadingView)

        statusLabel.textColor = .textGreen
        statusLabel.font = ._12CircularStdMedium
        statusLabel.numberOfLines = 0
        addSubview(statusLabel)

        statusImageView.image = UIImage(named: "happyPear")
        addSubview(statusImageView)

        messageLabel.font = UIFont._16CircularStdMedium
        messageLabel.textColor = .textBlack
        messageLabel.numberOfLines = 0
        backgroundShadingView.addSubview(messageLabel)

        pearImageView.image = UIImage(named: "happyPear")
        pearImageView.layer.cornerRadius = pearImageSize.width / 2
        pearImageView.layer.shadowColor = UIColor.black.cgColor
        pearImageView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        pearImageView.layer.shadowOpacity = 0.15
        pearImageView.layer.shadowRadius = 2
        backgroundShadingView.addSubview(pearImageView)
    }

    private func setupConstraints() {
        let statusImageSize = CGSize(width: 10, height: 10)
        let statusPadding = 4
        let statusMessagePadding = 4
        let pearSidePadding = 8
        let messageLeadingPadding = 12
        let messageTrailingPadding = 8

        statusImageView.snp.makeConstraints { make in
            make.size.equalTo(statusImageSize)
            make.leading.equalToSuperview()
            make.centerY.equalTo(statusLabel)
        }

        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusImageView.snp.trailing).offset(4)
            make.top.equalToSuperview()
        }

        backgroundShadingView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(statusMessagePadding)
            make.leading.trailing.bottom.equalToSuperview()
        }

        pearImageView.snp.makeConstraints { make in
            make.leading.equalTo(backgroundShadingView).inset(pearSidePadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(pearImageSize)
        }

        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(pearImageView.snp.trailing).offset(messageLeadingPadding)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(messageTrailingPadding)
        }

    }

    private func setupForNewPair() {

    }

    private func setupForReachOut() {

    }

    private func setupForChatScheduled() {

    }
}
