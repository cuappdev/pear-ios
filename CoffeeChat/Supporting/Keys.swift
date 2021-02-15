//
//  Keys.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 1/31/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct Keys {

    static let googleClientID = Keys.googleServiceDict["CLIENT_ID"] as? String ?? ""
    static let serverURL = Keys.keyDict["SERVER_URL"] as? String ?? ""
    static let instagramAppID = Keys.keyDict["INSTAGRAM_APP_ID"] as? String ?? ""
    static let instagramAppSecret = Keys.keyDict["INSTAGRAM_APP_SECRET"] as? String ?? ""

    private static let googleServiceDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

}
