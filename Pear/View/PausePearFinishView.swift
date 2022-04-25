//
//  PausePearFinishView.swift
//  Pear
//
//  Created by Vian Nguyen on 3/2/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class PausePearFinishView: UIView {

    // MARK: - Private View Vars
    private let finishLabel = UILabel()
    private let feedbackLabel = UILabel()
    private let feedbackButton = UIButton()
    private let cancelButton = UIButton()
    private let pearImageView = UIImageView()

    // MARK: - Private Data Vars
    private weak var delegate: PausePearDelegate?
    
    init(delegate: PausePearDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setUpViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        backgroundColor = .backgroundLightGreen
        layer.cornerRadius = 36
        frame.size = CGSize(width: 295, height: 382)
        
        finishLabel.text = "See you soon!"
        finishLabel.font = ._20CircularStdBook
        finishLabel.textAlignment = .center
        finishLabel.textColor = .black
        addSubview(finishLabel)
        
        feedbackLabel.text = "Let us know why you are leaving with some feedback."
        feedbackLabel.font = ._16CircularStdBook
        feedbackLabel.textAlignment = .center
        feedbackLabel.textColor = .black
        feedbackLabel.numberOfLines = 2
        addSubview(feedbackLabel)
        
        feedbackButton.setTitle("Sure", for: .normal)
        feedbackButton.setTitleColor(.white, for: .normal)
        feedbackButton.titleLabel?.font = ._16CircularStdMedium
        feedbackButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2.2
        feedbackButton.backgroundColor = .backgroundOrange
        feedbackButton.layer.shadowColor = UIColor.black.cgColor
        feedbackButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        feedbackButton.layer.shadowOpacity = 0.15
        feedbackButton.layer.shadowRadius = 2
        feedbackButton.addTarget(self, action: #selector(feedbackButtonPressed), for: .touchUpInside)
        addSubview(feedbackButton)

        cancelButton.setTitle("No Thanks", for: .normal)
        cancelButton.setTitleColor(.darkGreen, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = ._16CircularStdBold
        cancelButton.addTarget(self, action: #selector(cancelPause), for: .touchUpInside)
        addSubview(cancelButton)
        
        pearImageView.image = UIImage(named: "happyPear")
        pearImageView.contentMode = .scaleAspectFill
        pearImageView.layer.shadowColor = UIColor.black.cgColor
        pearImageView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        pearImageView.layer.shadowOpacity = 0.15
        pearImageView.layer.shadowRadius = 7.25
        addSubview(pearImageView)
    }

    private func setButtonAppearance(button: UIButton) {
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = ._16CircularStdBook
    }

    private func setupConstraints() {
        let cancelButtonSize = CGSize(width: 85, height: 20)
        let feedbackButtonSize = CGSize(width: 195.62, height: 48)
        let feedbackLabelSize = CGSize(width: 226, height: 50)
        let finishLabelSize = CGSize(width: 128, height: 25)
        let pearImageSize = CGSize(width: 87, height: 87)
        
        pearImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.size.equalTo(pearImageSize)
        }

        finishLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pearImageView.snp.bottom).offset(18)
            make.size.equalTo(finishLabelSize)
        }
        
        feedbackLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(finishLabel.snp.bottom).offset(18)
            make.size.equalTo(feedbackLabelSize)
        }
        
        feedbackButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(feedbackLabel.snp.bottom).offset(24)
            make.size.equalTo(feedbackButtonSize)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(feedbackButton.snp.bottom).offset(22)
            make.size.equalTo(cancelButtonSize)
        }
    }
    
    @objc private func feedbackButtonPressed() {
        //TODO: present feedback view
    }
    
    @objc private func cancelPause() {
        //TODO: remove current pop up view
    }

}


