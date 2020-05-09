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

    // MARK: - Private Data Vars
    private let userDefaults = UserDefaults.standard

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
        welcomeLabel.textColor = .textBlack
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

    private func createUser() {
        if let idToken = userDefaults.string(forKey: Constants.UserDefaults.userIdToken) {
            NetworkManager.shared.createUser(idToken: idToken).observe { result in
                switch result {
                case .value(let response):
                    print(response)
                case .error(let error):
                    print(error)
                }
            }
        }
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

        if let userId = user.userID,
            let userToken = user.authentication.idToken,
            let userFirstName = user.profile.givenName,
            let userFullName = user.profile.name {
            userDefaults.set(userId, forKey: Constants.UserDefaults.userId)
            userDefaults.set(userToken, forKey: Constants.UserDefaults.userIdToken)
            userDefaults.set(userFirstName, forKey: Constants.UserDefaults.userFirstName)
            userDefaults.set(userFullName, forKey: Constants.UserDefaults.userFullName)
            createUser()
        }

        let onboardingCompleted = userDefaults.bool(forKey: Constants.UserDefaults.onboardingCompletion)

        if onboardingCompleted {
            let homeVC = HomeViewController()
            navigationController?.pushViewController(homeVC, animated: false)
        } else {
            let onboardingVC = OnboardingPageViewController(
                transitionStyle: UIPageViewController.TransitionStyle.scroll,
                navigationOrientation: UIPageViewController.NavigationOrientation.horizontal
            )
            navigationController?.pushViewController(onboardingVC, animated: false)
        }
    }

    // Animate error alert view pop up dismissal in 0.15 seconds
    func removeAlertView(isDismiss: Bool) {
        UIView.animate(withDuration: 0.15, animations: {
            self.errorMessageVisualEffectView.alpha = 0
            self.errorMessageAlertView.alpha = 0
            self.errorMessageAlertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (_) in
            self.errorMessageAlertView.removeFromSuperview()
        }

    }
}
