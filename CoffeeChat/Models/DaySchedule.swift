//
//  DaySchedule.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct DaySchedule: Codable {

    let day: String
    let times: [Float]

    /// Returns the next Date corresponding to the first day and time of this DaySchedule
    func getDate() -> Date {
        let firstTime = times.first ?? 0
        return Time.next(Weekday.fromString(day), at: firstTime)
    }

    /// Returns true if the date corresponding to the day and first time in times has passed for this week
    // "This week" is determined by getting the next occurence of the date with getDate and seeing if its after saturday
    func hasPassed() -> Bool {
        // TODO
        let nextSunday = Time.next(.sunday, at: 0)
        let matchDate = getDate()
        return matchDate >= nextSunday
    }

}
