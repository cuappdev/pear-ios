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

    private let loginButton = GIDSignInButton()
    private let logoImageView = UIImageView()
    private let userDefaults = UserDefaults.standard

    private let logoSize = CGSize(width: 150, height: 150)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self

        loginButton.style = .wide
        view.addSubview(loginButton)

        logoImageView.layer.cornerRadius = logoSize.width/2
        logoImageView.backgroundColor = .inactiveGreen
        view.addSubview(logoImageView)

        setupConstraints()
    }

    private func setupConstraints() {
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
        }

        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.size.equalTo(logoSize)
        }
    }

}

extension LoginViewController: GIDSignInDelegate {

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
            let alertController = UIAlertController(title: Constants.Alerts.LoginFailure.title, message: Constants.Alerts.LoginFailure.message, preferredStyle: .alert)
            let action = UIAlertAction(title: Constants.Alerts.LoginFailure.action, style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
            return
        }

        if let userId = user.userID,
            let userToken = user.authentication.idToken,
            let userFirstName = user.profile.givenName,
            let userFullName = user.profile.name {
            userDefaults.set(userId, forKey: Constants.UserDefaults.userId)
            userDefaults.set(userToken, forKey: Constants.UserDefaults.userToken)
            userDefaults.set(userFirstName, forKey: Constants.UserDefaults.userFirstName)
            userDefaults.set(userFullName, forKey: Constants.UserDefaults.userFullName)
        }

        let onboardingCompleted = userDefaults.bool(forKey: Constants.UserDefaults.onboardingCompletion)

        if onboardingCompleted {
            let onboardingVC = OnboardingPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal)
            navigationController?.pushViewController(onboardingVC, animated: false)
        } else {
            let homeVC = HomeViewController()
            navigationController?.pushViewController(homeVC, animated: false)
        }
    }

}
