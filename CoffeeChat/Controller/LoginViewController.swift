//
//  LoginViewController.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import GoogleSignIn
import SnapKit
import UIKit

class LoginViewController: UIViewController {

    // MARK: - Private View Vars
    private var errorBlurEffect: UIBlurEffect!
    private var errorMessageAlertView: MessageAlertView!
    private var errorMessageVisualEffectView: UIVisualEffectView!
    private let loginButton = GIDSignInButton()
    private let logoImageView = UIImageView()
    private let welcomeLabel = UILabel()

    // MARK: - Private Constants
    private let loginButtonSize = CGSize(width: 202, height: 50)
    private let logoSize = CGSize(width: 146, height: 146)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self

        welcomeLabel.text = "Welcome to Pear"
        welcomeLabel.textColor = .black
        welcomeLabel.font = ._24CircularStdMedium
        view.addSubview(welcomeLabel)

        logoImageView.layer.cornerRadius = logoSize.width/2
        logoImageView.image = UIImage(named: "happyPear")
        view.addSubview(logoImageView)

        loginButton.style = .wide
        view.addSubview(loginButton)

        setupErrorMessageAlert()
        setupConstraints()
    }

    private func setupConstraints() {
        let welcomeLabelHeight: CGFloat = 30
        let welcomeLabelPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 100)

        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(welcomeLabelHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(welcomeLabelPadding)
        }

        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(97)
            make.size.equalTo(logoSize)
        }

        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(52)
            make.size.equalTo(loginButtonSize)
        }
    }

    private func setupErrorMessageAlert() {
        errorMessageAlertView = MessageAlertView(
            delegate: self,
            mainMessage: Constants.Alerts.LoginFailure.message,
            actionMessage: "Try Again",
            dismissMessage: "" // Empty string because there is no dismiss option for alert.
        )
        errorBlurEffect = UIBlurEffect(style: .light)
        errorMessageVisualEffectView = UIVisualEffectView(effect: errorBlurEffect)
    }

    private func showErrorMessageAlertView() {
        view.addSubview(errorMessageAlertView)

        errorMessageAlertView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(250)
            make.width.equalTo(292)
        }

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.errorMessageAlertView.transform = .init(scaleX: 1.5, y: 1.5)
            self.errorMessageVisualEffectView.alpha = 1
            self.errorMessageAlertView.alpha = 1
            self.errorMessageAlertView.transform = .identity
        })
    }

}

extension LoginViewController: GIDSignInDelegate, MessageAlertViewDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }

        if let email = user.profile.email, !(email.contains("@cornell.edu")) {
            GIDSignIn.sharedInstance().signOut()
            self.showErrorMessageAlertView()
            return
        }
        
        let onboardingVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
//        let onboardingCompleted = UserDefaults.standard.bool(forKey: Constants.UserDefaults.onboardingCompletion)
        let onboardingCompleted = false
        let loginVC = LoginViewController()

        if let idToken = user.authentication.idToken,
           let userFirstName = user.profile.givenName,
           let userFullName = user.profile.name,
           let userEmail = user.profile.email,
           let userProfilePictureURL = user.profile.imageURL(withDimension: 300) {
            let userNetId = userEmail[..<userEmail.firstIndex(of: "@")!]
            UserDefaults.standard.set(userNetId, forKey: Constants.UserDefaults.userNetId)
            UserDefaults.standard.set(userFirstName, forKey: Constants.UserDefaults.userFirstName)
            UserDefaults.standard.set(userFullName, forKey: Constants.UserDefaults.userFullName)
            UserDefaults.standard.set(userProfilePictureURL, forKey: Constants.UserDefaults.userProfilePictureURL)
            NetworkManager.shared.createUser(idToken: idToken).observe { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        // TODO: Add user creation handling
                        let userSession = response.data
                        print(userSession)
                        UserDefaults.standard.set(userSession.accessToken, forKey: Constants.UserDefaults.accessToken)
                        UserDefaults.standard.set(userSession.refreshToken, forKey: Constants.UserDefaults.refreshToken)
                        UserDefaults.standard.set(userSession.sessionExpiration, forKey: Constants.UserDefaults.sessionExpiration)
                        let vc = onboardingCompleted ? HomeViewController() : onboardingVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    case .error:
                        self.navigationController?.pushViewController(loginVC, animated: false)
                    }
                }
            }
        }
    }

    // Animate error alert view pop up dismissal in 0.15 seconds
    func removeAlertView(isDismiss: Bool) {
        UIView.animate(withDuration: 0.15, animations: {
            self.errorMessageVisualEffectView.alpha = 0
            self.errorMessageAlertView.alpha = 0
            self.errorMessageAlertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.errorMessageAlertView.removeFromSuperview()
        }
    }

}
