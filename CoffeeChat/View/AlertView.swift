//
//  AlertView.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/20/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

protocol AlertViewDelegate {
    func dismissAlertView()
}

class AlertView: UIView {

    var delegate: AlertViewDelegate?

    let statusImageView = UIImageView()
    let successMessageLabel = UILabel()
    let successLabel = UILabel()
    let cancelSignInButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundWhite

        statusImageView.image = UIImage(named: "sadPear")
        addSubview(statusImageView)

        successLabel.text = "Please login with your Cornell email."
        successLabel.numberOfLines = 0
        successLabel.textAlignment = .center
        successLabel.font = ._20CircularStdBook
        successLabel.textColor = .textBlack
        addSubview(successLabel)

        cancelSignInButton.setTitle("Try Again", for: .normal)
        cancelSignInButton.layer.cornerRadius = 27
        cancelSignInButton.backgroundColor = .backgroundOrange
        cancelSignInButton.setTitleColor(.white, for: .normal)
        cancelSignInButton.titleLabel?.font = ._20CircularStdBold
        cancelSignInButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        addSubview(cancelSignInButton)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {

        statusImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
            make.top.equalToSuperview().offset(-50)
        }

        successLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
            make.leading.trailing.equalToSuperview().inset(23)
        }

        cancelSignInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(successLabel.snp.bottom).offset(31)
            make.leading.trailing.equalToSuperview().inset(38)
            make.height.equalTo(53)
        }
    }

    @objc func handleDismissal() {
        delegate?.dismissAlertView()
    }

}
