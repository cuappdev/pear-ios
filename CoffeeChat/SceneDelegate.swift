//
//  SceneDelegate.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import GoogleSignIn
import IQKeyboardManagerSwift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200 // TODO: Double check with design
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController(rootViewController: LoginViewController())
        if let signIn = GIDSignIn.sharedInstance(), signIn.hasPreviousSignIn() {
            signIn.restorePreviousSignIn()
            // Onboard user if they haven't done so yet, otherwise bring to home.
//            let onboardingCompleted = UserDefaults.standard.bool(forKey: Constants.UserDefaults.onboardingCompletion)
            let onboardingCompleted = false
            let refreshToken = UserDefaults.standard.string(forKey: Constants.UserDefaults.refreshToken)
            let assignedMatch = true
            let matchVC = assignedMatch ? HomeViewController() : NoMatchViewController()
            let rootVC = onboardingCompleted ? matchVC : OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            guard let unwrappedToken = refreshToken else {
                // Ask user to sign in if they have not signed in before.
                window.rootViewController = navigationController
                self.window = window
                window.makeKeyAndVisible()
                return
            }
            NetworkManager.shared.refreshUserSession(token: unwrappedToken).observe { result in
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        // TODO: Add user creation handling
                        let userSession = response.data
                        UserDefaults.standard.set(userSession.accessToken, forKey: Constants.UserDefaults.accessToken)
                        UserDefaults.standard.set(userSession.refreshToken, forKey: Constants.UserDefaults.refreshToken)
                        UserDefaults.standard.set(userSession.sessionExpiration, forKey: Constants.UserDefaults.sessionExpiration)
                        navigationController.pushViewController(rootVC, animated: false)
                    case .error(let error):
                    // TODO: Handle error
                        print(error)
                    }
                }
            }
        }
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
