//
//  LoginViewController.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Firebase
import FirebaseAuth
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
           let userFirstName = user.profile.givenName,
           let userFullName = user.profile.name,
           let userEmail = user.profile.email,
           let addressSignIndex = userEmail.firstIndex(of: "@"),
           let userProfilePictureURLString = user.profile.imageURL(withDimension: 100)?.absoluteString {
            UserDefaults.standard.set(userProfilePictureURLString, forKey: Constants.UserDefaults.userProfilePictureURL)
            UserDefaults.standard.set(userEmail[..<addressSignIndex], forKey: Constants.UserDefaults.userNetId)
            UserDefaults.standard.set(userFirstName, forKey: Constants.UserDefaults.userFirstName)
            UserDefaults.standard.set(userFullName, forKey: Constants.UserDefaults.userFullName)
            
            NetworkManager.authenticateUser(idToken: idToken) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let userSession):
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(userSession.accessToken, forKey: Constants.UserDefaults.accessToken)
                        
                        self.getUser()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getUser() {
        NetworkManager.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // If the user already exists and has onboarded, we push them directly to the HomeViewController.
                guard let user = try? result.get(), let hasOnboarded = user.hasOnboarded, hasOnboarded else {
                    let onboardingVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                    self.navigationController?.pushViewController(onboardingVC, animated: true)
                    return
                }
                
                self.navigationController?.pushViewController(HomeViewController(), animated: true)
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

        guard let email = user.profile.email,
              // Only allow users with Cornell emails or internal users (Pear email) to log in
              email.contains("@cornell.edu") || email == "cornellpearapp@gmail.com" else {
            GIDSignIn.sharedInstance().signOut()
            do {
                try Auth.auth().signOut()
            } catch {
              print("Error signing out: ", error)
            }
            self.showErrorMessageAlertView()
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                 print("Firebase authentication error: \(error.localizedDescription)")
            }
        }
        loginUser(user: user)
    }

}
