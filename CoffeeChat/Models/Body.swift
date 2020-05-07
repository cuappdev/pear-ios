//
//  Body.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

// MARK: - Request Bodies

struct UserSessionBody: Codable {

    let clubs: [String]
    let idToken: String
    let graduationYear: String
    let hometown: String
    let interests: [String]
    let major: String
    let pronouns: String
    
}

struct SessionBody: Codable {

    let token: String
    let isIos = true // TODO: Review if we have

}

struct DeviceTokenBody: Codable {

    let isIos = true
    let deviceToken: String

}
