//
//  Matching.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct Match: Codable, Equatable {

    let matchID: String
    let status: String
    let meetingTime: Float?
    let users: [String]
    let availabilities: [DaySchedule]

    /**
        Returns the netid of the person the user is paired with.
        Is `nil` if all netIDs match the user or was unable to retrieve the user's netID from UserDefaults
    */
    var pair: String? {
        let userNetID = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId)
        if let userNetID = userNetID {
            return (users.filter { $0 != userNetID }).first
        }
        return nil
    }

    /// `true` if there are still valid availabilities for the user to choose from
    var allAvailibilitiesPassed: Bool {
        let availabilities = self.availabilities

        let matchDays = availabilities.map { $0.day }
        var allPossibleMeetingDays = [
            Constants.Match.sunday,
            Constants.Match.monday,
            Constants.Match.tuesday,
            Constants.Match.wednesday,
            Constants.Match.thursday,
            Constants.Match.friday,
            Constants.Match.saturday
        ]

        // the days are sorted from sunday..saturday
        allPossibleMeetingDays = allPossibleMeetingDays.filter { matchDays.contains($0) }

        if let latestAvailability = (availabilities.filter { $0.day == allPossibleMeetingDays.last }).last {
            return Time.scheduleHasPassed(day: latestAvailability.day, times: latestAvailability.times)
        } else {
            return false
        }
    }

    static func == (lhs: Match, rhs: Match) -> Bool {
        lhs.matchID == rhs.matchID && lhs.status == rhs.status
    }

}
