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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self

        view.addSubview(loginButton)

        setupConstraints()
    }

    private func setupConstraints() {
        loginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
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

        print(user.userID)
        print(user.authentication.idToken)
        print(user.profile.name)
        
        if let email = user.profile.email, !(email.contains("@cornell.edu")) {
            GIDSignIn.sharedInstance().signOut()
            let alertController = UIAlertController(title: Constants.Alerts.LoginFailure.title, message: Constants.Alerts.LoginFailure.message, preferredStyle: .alert)
            let action = UIAlertAction(title: Constants.Alerts.LoginFailure.action, style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
            return
        }

        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
    }

}
