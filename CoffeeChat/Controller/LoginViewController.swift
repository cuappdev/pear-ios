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
    private let loginButton = GIDSignInButton()
    private let logoImageView = UIImageView()
    private let welcomeLabel = UILabel()

    private lazy var signInErrorAlertView: AlertView = {
        let view = AlertView()
        view.layer.cornerRadius = 36
        view.delegate = self
        return view
    }()

    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Private Data Vars
    private let userDefaults = UserDefaults.standard

    // MARK: - Private Constants
    private let logoSize = CGSize(width: 146, height: 146)
    private let loginButtonSize = CGSize(width: 202, height: 50)

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

    private func setUpPopUpConstraints() {

        view.addSubview(signInErrorAlertView)

        signInErrorAlertView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(280)
            make.width.equalTo(292)
        }

        signInErrorAlertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        signInErrorAlertView.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.visualEffectView.alpha = 1
            self.signInErrorAlertView.alpha = 1
            self.signInErrorAlertView.transform = CGAffineTransform.identity
        })
    }
}

extension LoginViewController: GIDSignInDelegate, AlertViewDelegate {

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
            self.setUpPopUpConstraints()
//            let alertController = UIAlertController(title: Constants.Alerts.LoginFailure.title, message: Constants.Alerts.LoginFailure.message, preferredStyle: .alert)
//            let action = UIAlertAction(title: Constants.Alerts.LoginFailure.action, style: .cancel, handler: nil)
//            alertController.addAction(action)
//            present(alertController, animated: true, completion: nil)
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

    func dismissAlertView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.visualEffectView.alpha = 0
            self.signInErrorAlertView.alpha = 0
            self.signInErrorAlertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.signInErrorAlertView.removeFromSuperview()
        }
    }

}
