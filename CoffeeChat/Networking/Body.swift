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

struct UpdateUserGroupsBody: Codable {

    let groups: [String]
    
}

struct UpdateUserGoalsBody: Codable {

    let goals: [String]
    
}

struct UpdateUserSocialMediaBody: Codable {
    
    let facebook: String
    let instagram: String
    
}

struct UpdateUserDemographicsBody: Codable {
    
    let graduationYear: String
    let hometown: String
    let major: String
    let pronouns: String
    let profilePictureURL: String
    
}

struct UpdateUserInterestsBody: Codable {
    
    let interests: [String]
    
}

struct MatchingBody: Codable {

    let netIDs: [String]
    let schedule: [DaySchedule]

}
