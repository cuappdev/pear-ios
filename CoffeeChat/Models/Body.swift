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

    let idToken: String

}

struct UserUpdateBody: Codable {

    let clubs: [String]
    let graduationYear: String
    let hometown: String
    let interests: [String]
    let major: String
    let pronouns: String

}

struct MatchingBody: Codable {

    let netIDs: [String]
    let schedule: [DaySchedule]

}
