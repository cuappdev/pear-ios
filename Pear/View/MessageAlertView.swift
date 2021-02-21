//
//  MessageAlertView.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/20/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

protocol MessageAlertViewDelegate: class {
    func removeAlertView(isDismiss: Bool)
}

class MessageAlertView: UIView {

    // MARK: - Private View Vars
    private let alertImageView = UIImageView()
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    private let dismissButton = UIButton()

    // MARK: - Private Data Vars
    private var actionMessage: String = ""
    private weak var delegate: MessageAlertViewDelegate?
    private var dismissMessage: String = ""
    private var hasDismissOption: Bool = false
    private var mainMessage: String = ""
    private var alertImageName: String = ""

    init(delegate: MessageAlertViewDelegate, mainMessage: String, actionMessage: String, dismissMessage: String, alertImageName: String) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.mainMessage = mainMessage
        self.actionMessage = actionMessage
        self.dismissMessage = dismissMessage
        self.hasDismissOption = dismissMessage != ""
        self.alertImageName = alertImageName
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .backgroundWhite

        layer.cornerRadius = 36

        alertImageView.image = UIImage(named: alertImageName)
        addSubview(alertImageView)

        messageLabel.text = mainMessage
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = ._20CircularStdBook
        messageLabel.textColor = .black
        addSubview(messageLabel)

        actionButton.setTitle(actionMessage, for: .normal)
        actionButton.layer.cornerRadius = 27
        actionButton.backgroundColor = .backgroundOrange
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = ._20CircularStdBold
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        addSubview(actionButton)

        if hasDismissOption {
            dismissButton.setTitle(dismissMessage, for: .normal)
            dismissButton.setTitleColor(.darkGreen, for: .normal)
            dismissButton.titleLabel?.font = ._16CircularStdMedium
            dismissButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
            addSubview(dismissButton)
        }
    }

    private func setupConstraints() {
        let actionButtonSize = CGSize(width: 216, height: 53)
        let dismissButtonSize = CGSize(width: 58, height: 21)

        alertImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
            make.top.equalToSuperview().offset(-50)
        }

        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
            make.leading.trailing.equalToSuperview().inset(23)
        }

        actionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(messageLabel.snp.bottom).offset(31)
            make.size.equalTo(actionButtonSize)
        }

        if hasDismissOption {
            dismissButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(actionButton.snp.bottom).offset(27)
                make.bottom.equalToSuperview().inset(25)
                make.size.equalTo(dismissButtonSize)
            }
        }
    }

    @objc func handleAction() {
        delegate?.removeAlertView(isDismiss: false)
    }

    @objc func handleDismissal() {
        delegate?.removeAlertView(isDismiss: true)
    }

}
