//
//  UnpausePearView.swift
//  Pear
//
//  Created by Vian Nguyen on 3/19/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class UnpausePearView: UIView {

    // MARK: - Private View Vars
    private let cancelButton = UIButton()
    private let headerLabel = UILabel()
    private let unpauseButton = DynamicButton()
    
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
        frame.size = CGSize(width: 295, height: 238)
        
        headerLabel.text = "Your Pear is already paused"
        headerLabel.font = ._20CircularStdBook
        headerLabel.textAlignment = .center
        headerLabel.textColor = .black
        headerLabel.numberOfLines = 2
        addSubview(headerLabel)
        
        unpauseButton.setTitle("Unpause", for: .normal)
        unpauseButton.setTitleColor(.white, for: .normal)
        unpauseButton.titleLabel?.font = ._16CircularStdMedium
        unpauseButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2
        unpauseButton.isEnabled = true
        unpauseButton.addTarget(self, action: #selector(unpauseButtonPressed), for: .touchUpInside)
        addSubview(unpauseButton)

        cancelButton.setTitle("Not Yet", for: .normal)
        cancelButton.setTitleColor(.darkGreen, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = ._16CircularStdBold
        cancelButton.addTarget(self, action: #selector(cancelPause), for: .touchUpInside)
        addSubview(cancelButton)
    }

    private func setupConstraints() {
        let cancelButtonSize = CGSize(width: 85, height: 20)
        let unpauseButtonSize = CGSize(width: 195, height: 48)
        let headerLabelSize = CGSize(width: 195, height: 55)

        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.size.equalTo(headerLabelSize)
        }
        
        unpauseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerLabel.snp.bottom).offset(22)
            make.size.equalTo(unpauseButtonSize)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.size.equalTo(cancelButtonSize)
        }
    }
    
    @objc private func unpauseButtonPressed() {
        NetworkManager.pauseOrUnpausePear(isPausing: false, pauseWeeks: 0) {
            [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.delegate?.didUpdatePauseStatus()
                } else {
                    self.delegate?.presentErrorAlert()
                }
                Animations.removePopUpView(popUpView: self)
            }
        }
    }
    
    @objc private func cancelPause() {
        Animations.removePopUpView(popUpView: self)
    }

}
