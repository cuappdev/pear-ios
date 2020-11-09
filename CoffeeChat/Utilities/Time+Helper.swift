//
//  Time+Helper.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 4/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

    static func fromString(_ day: String) -> Weekday {
        let day = day.lowercased()
        if let weekday = Weekday(rawValue: day) {
            return weekday
        } else {
            print("Tried to create a Weekday with \(day); returning .monday instead")
            return .monday
        }
    }
}

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
        let calendar = Calendar.current
        if
            let today = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date()),
            let meetingDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)
        {
            if let dayDifference = calendar.dateComponents([.day], from: today, to: meetingDate).day {
                return dayDifference <= 1
            }
        }

        return false
    }

    static func next(_ weekday: Weekday, time: Float) -> Date {
        // Set today to have time specified by [time]
        let rightNow = Date()
        let hoursMinutes = Time.floatTimeToHoursMinutes(time: time)
        guard let todayWithTime = Calendar.current.date(
            bySettingHour: hoursMinutes.hours,
            minute: hoursMinutes.minutes,
            second: 0,
            of: rightNow
        ) else {
            fatalError("""
            A date could not be found that matches the components using the current Calendar:
            calendar: \(Calendar.current)
            hours: \(hoursMinutes.hours)
            minutes: \(hoursMinutes.minutes)
            base date: \(rightNow)
            """)
        }

        // If todayWithTime hasn't passed yet, return it
        if rightNow <= todayWithTime {
            return todayWithTime
        }

        // Move date to the next weekday
        let dayName = weekday.rawValue
        let weekdaysName = Time.getWeekDaysInEnglish().map { $0.lowercased() }
        guard var searchWeekdayIndex = weekdaysName.firstIndex(of: dayName) else {
            fatalError("weekday symbol should be in the form \(weekdaysName)")
        }
        searchWeekdayIndex += 1
        let calendar = Calendar(identifier: .gregorian)
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: todayWithTime)
        nextDateComponent.weekday = searchWeekdayIndex

        guard let date = calendar.nextDate(
            after: todayWithTime,
            matching: nextDateComponent,
            matchingPolicy: .nextTime,
            direction: .forward
        ) else {
            fatalError("""
            A date could not be found that matches the components using the current Calendar:
            calendar: \(calendar)
            dateComponents: \(nextDateComponent)
            matchingPolicy: \(Calendar.MatchingPolicy.nextTime)
            direction: \(Calendar.SearchDirection.forward)
            """)
        }

        return date
    }
}

// MARK: Helper Functinos
extension Time {

    /// Converts a float time to 2 integers representing hours and minutes.
    /// Currenlty only returns either on the hour times or half hours
    private static func floatTimeToHoursMinutes(time: Float) -> (hours: Int, minutes: Int) {
        let hours = Int(time)
        let minutes = time.rounded() > time ? 30 : 0
        return (hours, minutes)
    }

    private static func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }

}
