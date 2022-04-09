//
//  BlockUserView.swift
//  Pear
//
//  Created by Vian Nguyen on 3/20/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class BlockUserView: UIView {
    
    // MARK: - Private View Vars
    private let headerLabel = UILabel()
    private let blockButton = DynamicButton()
    private let cancelButton = UIButton()
    
    // MARK: - Private Data Vars
    private weak var blockDelegate: BlockDelegate?
    private var blockedUserId: Int?
    private var isBlocking = true
    
    init(blockDelegate: BlockDelegate?, userId: Int, isBlocking: Bool) {
        super.init(frame: .zero)
        self.blockDelegate = blockDelegate
        self.blockedUserId = userId
        self.isBlocking = isBlocking
        
        setUpViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        backgroundColor = .backgroundLightGreen
        layer.cornerRadius = 36
        frame.size = CGSize(width: 295, height: 219)
            
        headerLabel.text = "Are you sure?"
        headerLabel.font = ._20CircularStdBook
        headerLabel.textAlignment = .center
        headerLabel.textColor = .black
        addSubview(headerLabel)

        blockButton.setTitle(isBlocking ? "Block" : "Unblock", for: .normal)
        blockButton.setTitleColor(.white, for: .normal)
        blockButton.titleLabel?.font = ._16CircularStdBold
        blockButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2
        blockButton.backgroundColor = .backgroundOrange
        blockButton.isEnabled = true
        blockButton.addTarget(self, action: #selector(blockButtonPressed), for: .touchUpInside)
        addSubview(blockButton)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.darkGreen, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = ._16CircularStdBold
        cancelButton.addTarget(self, action: #selector(cancelBlock), for: .touchUpInside)
        addSubview(cancelButton)
        
    }
    
    private func setupConstraints() {
        let headerLabelSize = CGSize(width: 126, height: 25)
        let blockButtonSize = CGSize(width: 196, height: 48)
        let cancelButtonSize = CGSize(width: 85, height: 20)
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.size.equalTo(headerLabelSize)
        }

        blockButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerLabel.snp.bottom).offset(24)
            make.size.equalTo(blockButtonSize)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.size.equalTo(cancelButtonSize)
        }
    }
    
    @objc private func blockButtonPressed() {
        guard let userId = blockedUserId else { return }
        blockorUnblockUser(isBlocking: isBlocking, userId: userId)
        Animations.removePopUpView(popUpView: self)
    }
    
    @objc private func cancelBlock() {
        Animations.removePopUpView(popUpView: self)
    }
    
    private func blockorUnblockUser(isBlocking: Bool, userId: Int) {
        NetworkManager.blockorUnblockUser(isBlocking: isBlocking, userId: userId) {
            [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.blockDelegate?.didBlockorUnblockUser()
                } else {
                    self.blockDelegate?.presentErrorAlert()
                }
            }
        }
    }
}
