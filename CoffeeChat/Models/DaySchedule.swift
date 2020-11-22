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

    /// Is true if the date corresponding to the day and first time in times has passed for this week
    /// "This week" is determined by getting the next occurence of the date with getDate and seeing if its after saturday
    /// If this `DaySchedule` doesn't correspond to a day, is `false`
    var hasPassed: Bool {
        let nextSunday = Time.next(.sunday, at: 0)
        if let matchDate = nextCorrespondingDate {
            return matchDate >= nextSunday
        } else {
            return false
        }
    }


    /// Is the next `Date` corresponding to the next day and time of this DaySchedule, nil if `day`
    /// doesn't represent a valid string
    var nextCorrespondingDate: Date? {
        let firstTime = times.first ?? 0
        if let weekday = Weekday(rawValue: day) {
            return Time.next(weekday, at: firstTime)
        } else {
            return nil
        }
    }

}
