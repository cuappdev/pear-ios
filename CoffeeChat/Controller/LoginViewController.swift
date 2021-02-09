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
    private let backgroundImage = UIImageView()
    private var errorBlurEffect: UIBlurEffect!
    private var errorMessageAlertView: MessageAlertView!
    private var errorMessageVisualEffectView: UIVisualEffectView!
    private let loginButton = GIDSignInButton()

    // MARK: - Private Constants
    private let loginButtonSize = CGSize(width: 202, height: 50)
    private let logoSize = CGSize(width: 146, height: 146)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true

        backgroundImage.image = UIImage(named: "welcomeBackground")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self

        loginButton.style = .wide
        view.addSubview(loginButton)

        setupErrorMessageAlert()
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImage.frame = view.bounds
    }

    private func setupConstraints() {
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(96)
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

        if let email = user.profile.email, !(email.contains("@cornell.edu")) && email != "cornellpearapp@gmail.com" {
            GIDSignIn.sharedInstance().signOut()
            self.showErrorMessageAlertView()
            return
        }

        let onboardingVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        let onboardingCompleted = UserDefaults.standard.bool(forKey: Constants.UserDefaults.onboardingCompletion)
        let loginVC = LoginViewController()
        var base64Str = ""
        if let idToken = user.authentication.idToken,
           let userFirstName = user.profile.givenName,
           let userFullName = user.profile.name,
           let userEmail = user.profile.email,
           let userProfilePictureURL = user.profile.imageURL(withDimension: 25) {
            let profileURLData = try? Data(contentsOf: userProfilePictureURL)
            if let profileURLData = profileURLData,
               let profileImage = UIImage(data: profileURLData),
               let profileImagePngData = profileImage.pngData() {
                base64Str = profileImagePngData.base64EncodedString()
            }
            let userNetId = userEmail[..<userEmail.firstIndex(of: "@")!]
            UserDefaults.standard.set(userNetId, forKey: Constants.UserDefaults.userNetId)
            UserDefaults.standard.set(userFirstName, forKey: Constants.UserDefaults.userFirstName)
            UserDefaults.standard.set(userFullName, forKey: Constants.UserDefaults.userFullName)
            UserDefaults.standard.set(base64Str, forKey: Constants.UserDefaults.userProfilePictureURL)
            NetworkManager.shared.createUser(idToken: idToken).observe { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        let userSession = response.data
                        UserDefaults.standard.set(userSession.accessToken, forKey: Constants.UserDefaults.accessToken)
                        UserDefaults.standard.set(userSession.refreshToken, forKey: Constants.UserDefaults.refreshToken)
                        UserDefaults.standard.set(userSession.sessionExpiration, forKey: Constants.UserDefaults.sessionExpiration)
                        let vc = onboardingCompleted ? HomeViewController() : onboardingVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    case .error(let error):
                        print(error)
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
