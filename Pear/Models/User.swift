//
//  User.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {

    let firstName: String
    let goals: [String]
    let googleID: String
    let graduationYear: String?
    let groups: [String]
    let hometown: String
    let interests: [String]
    let lastName: String
    let major: String
    let netID: String
    let profilePictureURL: String
    let pronouns: String
    let facebook: String?
    let instagram: String?
    let talkingPoints: [String]
    let availabilities: [DaySchedule]
    let preferredLocations: [Location]
    let matches: [Match]

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.firstName == rhs.firstName &&
        lhs.goals == rhs.goals &&
        lhs.googleID == rhs.googleID &&
        lhs.graduationYear == rhs.graduationYear &&
        lhs.groups == rhs.groups &&
        lhs.hometown == rhs.hometown &&
        lhs.interests == rhs.interests &&
        lhs.lastName == rhs.lastName &&
        lhs.major == rhs.major &&
        lhs.netID == rhs.netID &&
        lhs.profilePictureURL == rhs.profilePictureURL &&
        lhs.pronouns == rhs.pronouns &&
        lhs.facebook == rhs.facebook &&
        lhs.instagram == rhs.instagram &&
        lhs.talkingPoints == rhs.talkingPoints &&
        lhs.availabilities == rhs.availabilities &&
        lhs.matches == rhs.matches
    }

}
