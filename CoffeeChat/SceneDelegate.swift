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

    private let userDefaults = UserDefaults.standard
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = scene as? UIWindowScene else { return }

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200 // TODO: Double check with design

        let window = UIWindow(windowScene: scene)
        guard let signIn = GIDSignIn.sharedInstance() else {
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            window.rootViewController = navigationController
            return
        }
        if signIn.hasPreviousSignIn() {
            signIn.restorePreviousSignIn()
            // Onboard user if they haven't done so yet, otherwise bring to home.
            let onboardingCompleted = userDefaults.bool(forKey: Constants.UserDefaults.onboardingCompletion)
            let assignedMatch = false
            let homeVC = HomeViewController()
            let noMatchVC = NoMatchViewController()
            let onboardingVC = OnboardingPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal)
            let matchVC = assignedMatch ? homeVC : noMatchVC
            let rootVC = onboardingCompleted ? matchVC : onboardingVC
            let navigationController = UINavigationController(rootViewController: rootVC)
            window.rootViewController = navigationcontroller
        } else {
            // Ask user to sign in if they have not signed in before.
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            window.rootViewController = navigationcontroller
        }
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

