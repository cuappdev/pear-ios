//
//  User.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {

    let netID: String
    let firstName: String
    let lastName: String
    let hometown: String
    let profilePictureURL: String
    let major: String
    let graduationYear: String
    let pronouns: String
    let interests: [String]
    let groups: [String]
    let facebook: String?
    let instagram: String?
    let didOnboard: Bool?

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.netID == rhs.netID &&
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.hometown == rhs.hometown &&
        lhs.profilePictureURL == rhs.profilePictureURL &&
        lhs.major == rhs.major &&
        lhs.graduationYear == rhs.graduationYear &&
        lhs.pronouns == rhs.pronouns &&
        lhs.interests == rhs.interests &&
        lhs.groups == rhs.groups &&
        lhs.facebook == rhs.facebook &&
        lhs.instagram == rhs.instagram
    }

}
