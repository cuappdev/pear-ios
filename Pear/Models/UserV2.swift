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
    let profilePicUrl: String
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
    
}

struct MatchV2: Codable {
    let id: Int
    let status: String
    let matchedUser: MatchedUser
    let proposerId: Int?
    let acceptedIds: [Int]?
    let proposedMeetingTimes: [String]?
    let proposedLocations: [LocationV2]?
    let meetingLocation: LocationV2?
    let meetingTime: String?
}

// TODO: MatchedUser and CommunityUser can be combined
struct MatchedUser: Codable {
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
    let interests: [Interest]
    let groups: [Group]
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
    let users: [MatchedUser]
    let proposerId: Int?
    let acceptedIds: [Int]?
    let proposedMeetingTimes: [String]?
    let proposedLocations: [LocationV2]?
    let meetingLocation: LocationV2?
    let meetingTime: String?
}
