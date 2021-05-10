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
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        // Set up keyboard management library, helps to shift up view when keyboard becomes active
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200
        
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController(rootViewController: LoadingViewController())
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()

        if let signIn = GIDSignIn.sharedInstance(), signIn.hasPreviousSignIn() {
            signIn.restorePreviousSignIn()

            let didCompleteOnboarding = UserDefaults.standard.bool(forKey: Constants.UserDefaults.onboardingCompletion)
            let refreshToken = UserDefaults.standard.string(forKey: Constants.UserDefaults.refreshToken)
            let rootVC = didCompleteOnboarding ?
                HomeViewController() :
                OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

            guard let unwrappedToken = refreshToken else {
                navigationController.pushViewController(LoginViewController(), animated: false)
                window.rootViewController = navigationController
                return
            }
            
            NetworkManager.shared.refreshUserToken(token: unwrappedToken).observe { result in
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        let userSession = response.data
                        UserDefaults.standard.set(userSession.accessToken, forKey: Constants.UserDefaults.accessToken)
                        UserDefaults.standard.set(userSession.refreshToken, forKey: Constants.UserDefaults.refreshToken)
                        navigationController.pushViewController(rootVC, animated: false)
                        window.rootViewController = navigationController
                    case .error:
                        navigationController.pushViewController(LoginViewController(), animated: false)
                        window.rootViewController = navigationController
                    }
                }
            }
        } else {
            navigationController.pushViewController(LoginViewController(), animated: false)
            window.rootViewController = navigationController
        }
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

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
