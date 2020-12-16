//
//  User.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct User: Codable {

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
    let matches: [Match]

}
