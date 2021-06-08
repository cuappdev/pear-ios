//
//  SocialMediaViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/5/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class SocialMediaViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let disclaimerLabel = UILabel()
    private var facebookTextField = UITextField()
    private var instagramTextField = UITextField()
    private let nextButton = UIButton()
    private let skipButton = UIButton()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()

    init(delegate: OnboardingPageDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        titleLabel.text = "Connect your social\nmedia?"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        subtitleLabel.text = "Help your Pear contact you"
        subtitleLabel.textColor = .greenGray
        subtitleLabel.font = ._12CircularStdBook
        view.addSubview(subtitleLabel)

        setSocialMediaTextField(socialMediaTextField: instagramTextField)
        instagramTextField.placeholder = "@Instagram handle"
        let instagramImageView = UIImageView(image: UIImage(named: "instagram"))
        instagramImageView.frame = CGRect(x: 15, y: 15, width: 19, height: 19)
        instagramTextField.addSubview(instagramImageView)
        view.addSubview(instagramTextField)

        setSocialMediaTextField(socialMediaTextField: facebookTextField)
        facebookTextField.placeholder = "Facebook profile link"
        let facebookImageView = UIImageView(image: UIImage(named: "facebook"))
        facebookImageView.frame = CGRect(x: 15, y: 15, width: 19, height: 19)
        facebookTextField.addSubview(facebookImageView)
        view.addSubview(facebookTextField)

        disclaimerLabel.text = "Your information will only be shared with the verified Cornell students you are paired with."
        disclaimerLabel.textColor = .greenGray
        disclaimerLabel.font = ._12CircularStdBook
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.lineBreakMode = .byWordWrapping
        view.addSubview(disclaimerLabel)

        nextButton.setTitle("Ready for Pear", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = 26
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(completeOnboarding), for: .touchUpInside)
        view.addSubview(nextButton)

        skipButton.titleLabel?.font = ._16CircularStdMedium
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.inactiveGreen, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.isEnabled = false
        skipButton.addTarget(self, action: #selector(completeOnboarding), for: .touchUpInside)
        view.addSubview(skipButton)

        getUserSocialMedia()
        setupConstraints()
    }

    private func setSocialMediaTextField(socialMediaTextField: UITextField) {
        socialMediaTextField.backgroundColor = .backgroundWhite
        socialMediaTextField.textColor = .black
        socialMediaTextField.font = ._20CircularStdBook
        socialMediaTextField.clearButtonMode = .whileEditing
        socialMediaTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        socialMediaTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 49))
        socialMediaTextField.leftViewMode = .always
        socialMediaTextField.layer.cornerRadius = 8
        socialMediaTextField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        socialMediaTextField.layer.shadowOpacity = 1
        socialMediaTextField.layer.shadowRadius = 4
        socialMediaTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(6)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 318, height: 61))
            make.top
                .equalTo(view.safeAreaLayoutGuide)
                .offset(Constants.Onboarding.titleLabelPadding)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }

        disclaimerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview().inset(63)
        }

        instagramTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(49)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(62)
        }

        facebookTextField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(instagramTextField)
            make.top.equalTo(instagramTextField.snp.bottom).offset(16)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }

        skipButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 86, height: 20))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.skipBottomPadding)
        }
    }

    // MARK: - Next and Previous Buttons
    private func updateNext() {
        if let instagramHandle = instagramTextField.text,
           let facebookHandle = facebookTextField.text,
           (!instagramHandle.trimmingCharacters(in: .whitespaces).isEmpty ||
            !facebookHandle.trimmingCharacters(in: .whitespaces).isEmpty)
           {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .backgroundOrange
            skipButton.isEnabled = false
            skipButton.setTitleColor(.inactiveGreen, for: .normal)
        } else {
            skipButton.isEnabled = true
            skipButton.setTitleColor(.greenGray, for: .normal)
            nextButton.isEnabled = false
            nextButton.backgroundColor = .inactiveGreen
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateNext()
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 4)
    }

    @objc func completeOnboarding() {
        Networking2.updateSocialMedia(
            facebookUrl: facebookTextField.text,
            instagramUsername: instagramTextField.text
        ) { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    UserDefaults.standard.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
                    self.navigationController?.pushViewController(HomeViewController(), animated: true)
                } else {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
    }
    
    private func getUserSocialMedia() {
        Networking2.getMe { [weak self] user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let facebookUrl = user.facebookUrl {
                    self.facebookTextField.text = facebookUrl
                }
                if let instagramUsername = user.instagramUsername {
                    self.instagramTextField.text = instagramUsername
                }
                self.updateNext()
            }
        }
    }

}
