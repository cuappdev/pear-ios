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
    private let loginButton = GIDSignInButton()
    
    // MARK: - Error Alert Vars
    private var errorMessageAlertView: MessageAlertView!
    private var errorMessageVisualEffectView: UIVisualEffectView!

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
            make.size.equalTo(CGSize(width: 202, height: 50))
        }
    }

    private func showErrorMessageAlertView() {
        errorMessageAlertView = MessageAlertView(
            mainMessage: Constants.Alerts.LoginFailure.message,
            actionMessage: "Try Again",
            dismissMessage: "", // Empty string because there is no dismiss option for alert.
            alertImageName: "sadPear",
            removeFunction: { _ in
                UIView.animate(withDuration: 0.15, animations: {
                    self.errorMessageVisualEffectView.alpha = 0
                    self.errorMessageAlertView.alpha = 0
                    self.errorMessageAlertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { _ in
                    self.errorMessageAlertView.removeFromSuperview()
                }
            }
        )
        
        let errorBlurEffect = UIBlurEffect(style: .light)
        errorMessageVisualEffectView = UIVisualEffectView(effect: errorBlurEffect)
        view.addSubview(errorMessageVisualEffectView)

        errorMessageVisualEffectView.frame = view.bounds
        view.addSubview(errorMessageAlertView)
        
        errorMessageAlertView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(250)
            make.width.equalTo(292)
        }

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.errorMessageAlertView.transform = .init(scaleX: 1.5, y: 1.5)
            self.errorMessageAlertView.alpha = 1
            self.errorMessageAlertView.transform = .identity
            self.errorMessageVisualEffectView.alpha = 1
        })
    }

    private func loginUser(user: GIDGoogleUser) {
        if let idToken = user.authentication.idToken,
           let userEmail = user.profile.email,
           let addressSignIndex = userEmail.firstIndex(of: "@"),
           let userProfilePictureURL = user.profile.imageURL(withDimension: 100) {
            UserDefaults.standard.set(userProfilePictureURL, forKey: Constants.UserDefaults.userProfilePictureURL)
            UserDefaults.standard.set(userEmail[..<addressSignIndex], forKey: Constants.UserDefaults.userNetId)
            NetworkManager.shared.createUser(idToken: idToken).observe { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        let userSession = response.data
                        UserDefaults.standard.set(userSession.accessToken, forKey: Constants.UserDefaults.accessToken)
                        UserDefaults.standard.set(userSession.refreshToken, forKey: Constants.UserDefaults.refreshToken)
                        self.getUser()
                    case .error:
                        self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                        self.navigationController?.pushViewController(LoginViewController(), animated: false)
                    }
                }
            }
        }
    }

    private func getUser() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getUser(netId: netId).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        let onboardingCompleted = response.data.didOnboard
                        UserDefaults.standard.set(onboardingCompleted, forKey: Constants.UserDefaults.onboardingCompletion)
                        let viewController = onboardingCompleted ?
                            HomeViewController() :
                            OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                        self.navigationController?.pushViewController(viewController, animated: false)
                    }
                case .error:
                    print("Network error: could not get user.")
                }
            }
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

        if let email = user.profile.email,
           !(email.contains("@cornell.edu")) && email != "cornellpearapp@gmail.com" {
            GIDSignIn.sharedInstance().signOut()
            self.showErrorMessageAlertView()
            return
        }

        loginUser(user: user)
    }

}
