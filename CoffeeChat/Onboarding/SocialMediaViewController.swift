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
    private let facebookLabel = UILabel()
    private let facebookSwitch = UISwitch()
    private let instagramLabel = UILabel()
    private let instagramSwitch = UISwitch()
    private let nextButton = UIButton()
    private let skipButton = UIButton()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()
    
    private let button = UIButton()
    
    var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    var instagramUser: InstagramUser?
    var signedIn = false

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

        subtitleLabel.text = "It's best to connect at least one other account so you can get in touch with each other easily."
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .greenGray
        subtitleLabel.font = ._12CircularStdBook
        view.addSubview(subtitleLabel)
        
        facebookLabel.text = "Connect Facebook"
        view.addSubview(facebookLabel)
        
        facebookSwitch.addTarget(self, action: #selector(facebookSwitchValueDidChange), for: .valueChanged)
        view.addSubview(facebookSwitch)
        
        instagramLabel.text = "Connect Instagram"
        view.addSubview(instagramLabel)
        
        instagramSwitch.addTarget(self, action: #selector(instagramSwitchValueDidChange), for: .valueChanged)
        view.addSubview(instagramSwitch)

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

        getUserSocialMedia()
        setupConstraints()
    }

    private func setupConstraints() {
        let horizontalPadding = 40
        
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
            make.leading.trailing.equalTo(titleLabel)
        }

        disclaimerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview().inset(63)
        }

        instagramLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(49)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(62)
        }
        
        instagramSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(instagramLabel)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        facebookLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(49)
            make.top.equalTo(instagramLabel.snp.bottom).offset(16)
        }
        
        facebookSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(facebookLabel)
            make.trailing.equalToSuperview().inset(horizontalPadding)
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
    
    @objc func facebookSwitchValueDidChange() {
        
    }
    
    @objc func instagramSwitchValueDidChange() {
        if instagramSwitch.isOn {
            authenticateOrSignIn()
        } else {
            
        }
    }

    // MARK: - Next and Previous Buttons
    private func updateNext() {
//        guard let instagramHandle = instagramTextField.text, let facebookHandle = facebookTextField.text else { return }
//        let isSocialMediaEntered =
//            instagramHandle.trimmingCharacters(in: .whitespaces).isEmpty ||
//            facebookHandle.trimmingCharacters(in: .whitespaces).isEmpty
//        nextButton.isEnabled = isSocialMediaEntered
//        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
//        skipButton.isEnabled = !nextButton.isEnabled
//        let skipButtonColor: UIColor = skipButton.isEnabled ? .greenGray : .inactiveGreen
//        skipButton.setTitleColor(skipButtonColor, for: .normal)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateNext()
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 4)
    }

    @objc func nextButtonPressed() {
//        let instagramHandle = instagramTextField.text ?? ""
//        let facebookHandle = facebookTextField.text ?? ""
//        NetworkManager.shared.updateUserSocialMedia(facebook: facebookHandle, instagram: instagramHandle).observe { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .value(let response):
//                    if response.success {
//                        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
//                        self.navigationController?.pushViewController(HomeViewController(), animated: true)
//                    } else {
//                        self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
//                    }
//                case .error:
//                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
//                }
//            }
//        }
    }
    
    private func getUserSocialMedia() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getUser(netId: netId).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
//                        if let facebook = response.data.facebook {
//                            self.facebookTextField.text = facebook
//                        }
//                        if let instagram = response.data.instagram {
//                            self.instagramTextField.text = instagram
//                        }
                        self.updateNext()
                    } else {
                        print("Network error: could not get user social media.")
                    }
                case .error:
                    print("Network error: could not get user social media.")
                }
            }
        }
    }

    @objc func skipButtonPressed() {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Signed In:", message: "with account: @\(self.instagramUser!.username)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func presentWebViewController() {
        let webVC = WebViewController()
        webVC.mainVC = self
        self.present(webVC, animated: true)
    }
    
    func authenticateOrSignIn() {
        if self.testUserData.user_id == 0 {
            presentWebViewController()
        } else {
            InstagramAPI.shared.getInstagramUser(testUserData: self.testUserData) { [weak self] (user) in
                self?.instagramUser = user
                self?.signedIn = true
                DispatchQueue.main.async {
                    self?.presentAlert()
                }
            }
        }
    }

}
