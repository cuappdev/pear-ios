//
//  UserV2.swift
//  Pear
//
//  Created by Lucy Xu on 5/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

struct UserV2: Codable {
    let id: Int
    let netId: String
    let firstName: String
    let lastName: String
    let majors: [MajorV2]
    let hometown: String?
    var profilePicUrl: String
    let facebookUrl: String?
    let instagramUsername: String?
    let graduationYear: String?
    let pronouns: String?
    let goals: [String]?
    let talkingPoints: [String]?
    let availability: [String]?
    let locations: [LocationV2]?
    let interests: [Interest]
    let groups: [Group]
    let hasOnboarded: Bool?
    let pendingFeedback: Bool
    let currentMatch: MatchV2?
    let prompts: [Prompt]
}

struct MatchV2: Codable {
    let id: Int
    let status: String
    let matchedUser: CommunityUser
    let proposerId: Int?
    let acceptedIds: [Int]?
    let proposedMeetingTimes: [String]?
    let proposedLocations: [LocationV2]?
    let meetingLocation: LocationV2?
    let meetingTime: String?
}

struct CommunityUser: Codable {
    let id: Int
    let netId: String
    let firstName: String
    let lastName: String
    let hometown: String
    let majors: [MajorV2]
    let profilePicUrl: String?
    let graduationYear: String
    let pronouns: String?
    let interests: [Interest]
    let groups: [Group]
    let prompts: [Prompt]
    var isBlocked: Bool?
}

struct LocationV2: Codable {
    let id: String
    let name: String
    let area: String
}

// todo - fix naming
struct TempMatchV2: Codable {
    let id: Int
    let status: String
    let users: [CommunityUser]
    let proposerId: Int?
    let acceptedIds: [Int]?
    let proposedMeetingTimes: [String]?
    let proposedLocations: [LocationV2]?
    let meetingLocation: LocationV2?
    let meetingTime: String?
}
