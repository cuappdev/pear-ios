//
//  Keys.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 1/31/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct Keys {

    static let announcementsCommonPath = Keys.keyDict["announcements-common-path"] as! String
    static let announcementsHost = Keys.keyDict["announcements-host"] as! String
    static let announcementsPath = Keys.keyDict["announcements-path"] as! String
    static let announcementsScheme = Keys.keyDict["announcements-scheme"] as! String
    static let feedbackURL = Keys.keyDict["FEEDBACK_URL"] as? String ?? ""
    static let feedbackEmail = Keys.keyDict["feedback-email"] as? String ?? ""
    static let googleClientID = Keys.googleServiceDict["CLIENT_ID"] as? String ?? ""
    static let serverURL = Keys.keyDict["SERVER_URL"] as? String ?? ""

    private static let googleServiceDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

}
