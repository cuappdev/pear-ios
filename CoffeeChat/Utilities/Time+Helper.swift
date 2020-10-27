//
//  Time+Helper.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 4/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

class Time {

    static let amTimes = ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30"]
    static let pmTimes = [
        "12:00", "12:30", "1:00", "1:30", "2:00", "2:30",
        "3:00", "3:30", "4:00", "4:30", "5:00", "5:30",
        "6:00", "6:30", "7:00", "7:30", "8:00", "8:30"
    ]

    static func isAm(time: String) -> Bool {
        amTimes.contains(time)
    }

    static func isPm(time: String) -> Bool {
        pmTimes.contains(time)
    }

    /**
    Returns true if meeting is tommorow or today.
    "Tommorow" is defined as one calendar day after today rather than 24 hours ahead.

    # Example:
    If today is October 4th 12:00 PM and the meeting is October 5th 12:00 PM this returns true
    If today is October 4th 12:00 PM and the meeting is October 6th 12:00 PM this returns false
    If today is October 4th 1:00 AM and the meeting is October 5th 11:00 PM this returns true
    */
    static func isTommorow(_ date: Date) -> Bool {
        if
            let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()),
            let meetingDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)
        {
            if let dayDifference = Calendar.current.dateComponents([.day], from: today, to: meetingDate).day {
                return dayDifference <= 1
            }
        }

        return false
    }

}
