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
    let graduationYear: String?
    let pronouns: String
    let interests: [String]
    let groups: [String]

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.firstName == rhs.firstName &&
//        lhs.goals == rhs.goals &&
//        lhs.netID == rhs.netID &&
        lhs.graduationYear == rhs.graduationYear &&
        lhs.groups == rhs.groups &&
        lhs.hometown == rhs.hometown &&
        lhs.interests == rhs.interests &&
        lhs.lastName == rhs.lastName &&
        lhs.major == rhs.major &&
        lhs.netID == rhs.netID &&
        lhs.profilePictureURL == rhs.profilePictureURL &&
        lhs.pronouns == rhs.pronouns
//        lhs.facebook == rhs.facebook &&
//        lhs.instagram == rhs.instagram &&
//        lhs.talkingPoints == rhs.talkingPoints &&
//        lhs.availabilities == rhs.availabilities &&
//        lhs.matches == rhs.matches
    }

}
