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
    var firstName: String
    var lastName: String
    var majors: [MajorV2]
    var hometown: String?
    var profilePicUrl: String
    let facebookUrl: String?
    let instagramUsername: String?
    var graduationYear: String?
    var pronouns: String?
    let goals: [String]?
    let talkingPoints: [String]?
    let availability: [String]?
    let locations: [LocationV2]?
    var interests: [Interest]
    var groups: [Group]
    let hasOnboarded: Bool?
    let pendingFeedback: Bool
    let currentMatch: MatchV2?
    var prompts: [Prompt]
    let isPaused: Bool?
    let pauseExpiration: String?
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
    var firstName: String
    var lastName: String
    var hometown: String
    var majors: [MajorV2]
    var profilePicUrl: String?
    var graduationYear: String
    var pronouns: String?
    var interests: [Interest]
    var groups: [Group]
    var prompts: [Prompt]
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
