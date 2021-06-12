//
//  Body.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//
import Foundation

// MARK: - Photo Upload

struct PhotoUploadBody: Codable {

    let bucket: String
    let image: String

}

// MARK: - Request Bodies
struct UserSessionBody: Codable {

    let idToken: String

}

struct UpdateUserGoalsBody: Codable {

    let goals: [String]

}

struct UpdateUserTalkingPointsBody: Codable {

    let talkingPoints: [String]

}

struct MatchingBody: Codable {

    let netIDs: [String]
    let schedule: [DaySchedule]

}

struct UpdateMatchBody: Codable {

    let matchID: String
    let schedule: [DaySchedule]
}

struct UpdateTimeAvailabilitiesBody: Codable {

    let schedule: [DaySchedule]

}

struct UpdatePreferredLocationsBody: Codable {
    
    let preferences: [Location]
    
}

class DaySchedule: Codable, Equatable {

    var day: String
    var times: [Float]

    init(day: String, times: [Float]) {
        self.day = day
        self.times = times
    }

    static func == (lhs: DaySchedule, rhs: DaySchedule) -> Bool {
        return lhs.day == rhs.day && lhs.times == rhs.times
    }

}

struct Location: Codable {
    
    let area: String
    let name: String
    
}
