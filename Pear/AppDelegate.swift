//
//  AppDelegate.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import AppDevAnnouncements
import FutureNova
import GoogleSignIn
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Configure Google sign-in with client ID
        GIDSignIn.sharedInstance().clientID = Keys.googleClientID

        // Set up AppDev Announcements Feedback
        AnnouncementNetworking.setupConfig(
            scheme: Keys.announcementsScheme,
            host: Keys.announcementsHost,
            commonPath: Keys.announcementsCommonPath,
            announcementPath: Keys.announcementsPath
        )

        // Setup networking
        Endpoint.setupEndpointConfig()
        
        return true
    }

    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

