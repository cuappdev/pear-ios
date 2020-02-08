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

    private static let googleServiceDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

}

