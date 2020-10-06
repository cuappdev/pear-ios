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
    private let userDefaults = UserDefaults.standard

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let disclaimerLabel = UILabel()
    private let nextButton = UIButton()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let skipButton = UIButton()
    private let instagramTextField = UITextField()
    private let facebookTextField = UITextField()

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

//        instagramTextField.delegate = self
        instagramTextField.backgroundColor = .backgroundWhite
        instagramTextField.textColor = .black
        instagramTextField.font = ._20CircularStdBook
        instagramTextField.placeholder = "@Instagram Handle"
        instagramTextField.clearButtonMode = .never
        instagramTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let instagramImageView = UIImageView(image: UIImage(named: "instagram"))
        instagramImageView.frame = CGRect(x: 15, y: 15, width: 19, height: 19)
        instagramTextField.addSubview(instagramImageView)
        instagramTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 49))
        instagramTextField.leftViewMode = .always
        instagramTextField.layer.cornerRadius = 8
        instagramTextField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        instagramTextField.layer.shadowOpacity = 1
        instagramTextField.layer.shadowRadius = 4
        instagramTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(instagramTextField)

//        facebookTextField.delegate = self
        facebookTextField.backgroundColor = .backgroundWhite
        facebookTextField.textColor = .black
        facebookTextField.font = ._20CircularStdBook
        facebookTextField.placeholder = "Facebook profile link"
        facebookTextField.clearButtonMode = .never
        facebookTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let facebookImageView = UIImageView(image: UIImage(named: "facebook"))
        facebookImageView.frame = CGRect(x: 15, y: 15, width: 19, height: 19)
        facebookTextField.addSubview(facebookImageView)
        facebookTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 49))
        facebookTextField.leftViewMode = .always
        facebookTextField.layer.cornerRadius = 8
        facebookTextField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        facebookTextField.layer.shadowOpacity = 1
        facebookTextField.layer.shadowRadius = 4
        facebookTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
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
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        skipButton.titleLabel?.font = ._16CircularStdMedium
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.greenGray, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        view.addSubview(skipButton)

        setupConstraints()
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
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
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(49)
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

        guard let instagramHandle = instagramTextField.text, let facebookHandle = facebookTextField.text else { return }

        let isSocialMediaEntered = instagramHandle.trimmingCharacters(in: .whitespaces) != "" && facebookHandle.trimmingCharacters(in: .whitespaces) != ""

        print(isSocialMediaEntered)

        nextButton.isEnabled = isSocialMediaEntered
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
        skipButton.isEnabled = !nextButton.isEnabled
        let skipButtonColor: UIColor = skipButton.isEnabled ? .greenGray : .inactiveGreen
        skipButton.setTitleColor(skipButtonColor, for: .normal)

    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateNext()
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 4)
    }

    @objc func nextButtonPressed() {
        userDefaults.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }

    @objc func skipButtonPressed() {
        userDefaults.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }

}
