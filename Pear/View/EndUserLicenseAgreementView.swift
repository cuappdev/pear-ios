//
//  EndUserLicenseAgreementView.swift
//  Pear
//
//  Created by Vian Nguyen on 9/18/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

protocol UserAgreementDelegate: AnyObject {
    func presentUserLicenseAgreementWebView(url: URL)
}

class EndUserLicenseAgreementView: UIView {
        
    // MARK: - Private View Vars
    private let acceptButton = DynamicButton()
    private let descriptionLabel = UILabel()
    private let headerLabel = UILabel()
    private let licenseButton = UIButton()
    private let pearImageView = UIImageView()

    // MARK: - Private Data Vars
    private var delegate: UserAgreementDelegate?
    private let licenseURL = "https://www.cornellappdev.com/license/pear"
    private let licenseButtonText = NSMutableAttributedString.init(string: "End User License Agreement")
    
    init(delegate: UserAgreementDelegate?) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupViews();
        setupConstraints();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .backgroundLightGreen
        layer.cornerRadius = 36
        frame.size = CGSize(width: 314, height: 349)
            
        headerLabel.text = "Welcome to Pear!"
        headerLabel.font = ._20CircularStdBook
        headerLabel.textAlignment = .center
        headerLabel.textColor = .black
        addSubview(headerLabel)
        
        descriptionLabel.text = "By using Pear, you agree to the"
        descriptionLabel.font = ._16CircularStdBook
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        addSubview(descriptionLabel)
        
        licenseButtonText.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                    NSRange.init(location: 0, length: licenseButtonText.length))
        licenseButton.setAttributedTitle(licenseButtonText, for: .normal)
        licenseButton.setTitleColor(.darkGreen, for: .normal)
        licenseButton.titleLabel?.font = ._16CircularStdBook
        licenseButton.addTarget(self, action: #selector(licenseButtonPressed), for: .touchUpInside)
        addSubview(licenseButton)

        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.titleLabel?.font = ._20CircularStdBold
        acceptButton.isEnabled = true
        acceptButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2
        acceptButton.addTarget(self, action: #selector(acceptButtonPressed), for: .touchUpInside)
        addSubview(acceptButton)
        
        pearImageView.image = UIImage(named: "heartPear")
        pearImageView.contentMode = .scaleAspectFill
        pearImageView.layer.shadowColor = UIColor.black.cgColor
        pearImageView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        pearImageView.layer.shadowOpacity = 0.15
        pearImageView.layer.shadowRadius = 7.25
        addSubview(pearImageView)
    }
    
    private func setupConstraints() {
        let verticalPadding = 20
        let textIteritemSpacing = 5
        let acceptButtonSize = CGSize(width: 280, height: 55)
        let licenseButtonSize = CGSize(width: 250, height: 20)
        let pearImageSize = CGSize(width: 115, height: 118)

        pearImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(pearImageSize)
            make.top.equalToSuperview().offset(verticalPadding + textIteritemSpacing)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerLabel.snp.bottom).offset(3 * textIteritemSpacing)
        }
        
        licenseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(licenseButtonSize)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(textIteritemSpacing)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(acceptButtonSize)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }
        
    }
    
    @objc private func licenseButtonPressed() {
        guard let url = URL(string: licenseURL) else { return }
        delegate?.presentUserLicenseAgreementWebView(url: url)
    }
    
    @objc private func acceptButtonPressed() {
        UserDefaults.standard.set(true, forKey: "hasAcceptedTerms")
        Animations.removePopUpView(popUpView: self)
    }
    
}
