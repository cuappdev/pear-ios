//
//  User.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct User: Codable {

    let clubs: [String]
    let firstName: String
    let googleID: String
    let graduationYear: String
    let hometown: String
    let interests: [String]
    let lastName: String
    let major: String
    let matches: [Matching]?
    let netID: String
    let profilePictureURL: String
    let pronouns: String
    let facebook: String?
    let instagram: String?

    func toSubUser() -> SubUser {
        SubUser(
            facebook: facebook,
            firstName: firstName,
            googleID: googleID,
            graduationYear: graduationYear,
            hometown: hometown,
            instagram: instagram,
            lastName: lastName,
            netID: netID,
            profilePictureURL: profilePictureURL,
            pronouns: pronouns
        )
    }
}
