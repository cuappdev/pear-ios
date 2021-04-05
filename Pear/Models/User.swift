//
//  User.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {

    let didOnboard: Bool
    let graduationYear: String?
    let groups: [String]
    let hometown: String?
    let facebook: String?
    let firstName: String
    let interests: [String]
    let instagram: String?
    let lastName: String
    let major: String
    let netID: String
    let profilePictureURL: String?
    let pronouns: String?

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
