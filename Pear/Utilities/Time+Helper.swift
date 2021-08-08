//
//  Time+Helper.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 4/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

enum Weekday: String, CaseIterable {

    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    var calendarIndex: Int {
        Self.allCases.firstIndex(of: self)! + 1
    }
}

class Time {

    /// We only work with Gregorian Calendar times
    static let calendar = Calendar(identifier: .gregorian)

    /// Day of the week matches are first assigned
    static let matchDay: Weekday = .sunday

    static let daysAbbrev = ["Su", "M", "Tu", "W", "Th", "F", "Sa"]

    static let daysDict = [
        "Su": "Sunday",
        "M": "Monday",
        "Tu": "Tuesday",
        "W": "Wednesday",
        "Th": "Thursday",
        "F": "Friday",
        "Sa": "Saturday"
    ]

    /// Times available for meeting up
    static let amTimes = ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30"]
    static let pmTimes = [
        "12:00", "12:30", "1:00", "1:30", "2:00", "2:30",
        "3:00", "3:30", "4:00", "4:30", "5:00", "5:30",
        "6:00", "6:30", "7:00", "7:30", "8:00", "8:30"
    ]

    /// All possible times available for parts of a day
    static let allAfternoonTimes = ["1:00", "1:30", "2:00", "2:30", "3:00", "3:30", "4:00", "4:30"]
    static let allEveningTimes = ["5:00", "5:30", "6:00", "6:30", "7:00", "7:30", "8:00", "8:30"]
    static let allMorningTimes = ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30"]

    /// Returns the number of days its been since matches have been assigned
    static var daysSinceMatching: Int {
        let lastSunday = getWeekday(searchDirection: .backward, weekday: .sunday, time: 0)
        let today = Date()
        return Time.calendar.dateComponents([.day], from: lastSunday, to: today).day ?? 0
    }

    static var thisYear: Int {
        Calendar.current.component(.year, from: Date())
    }

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
        if let today = Time.calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date()),
            let meetingDate = Time.calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date),
            let dayDifference = Time.calendar.dateComponents([.day], from: today, to: meetingDate).day {
            return dayDifference <= 1
        }

        return false
    }

    /// Returns the `Date` corresponding to next `weekday` at the time specified by `time`
    static func next(_ weekday: Weekday, at time: Float) -> Date {
        getWeekday(searchDirection: .forward, weekday: weekday, time: time)
    }

    /**
    Returns the next `Date` corresponding to the next date specified by `day` and the largest float in `times`.
    Returns nil if `day`doesn't represent a valid string or times is empty.
    */
    static func next(day: String, times: [Float]) -> Date? {
        let firstTime = times.max() ?? 0
        if let weekday = Weekday(rawValue: day) {
            return Time.next(weekday, at: firstTime)
        } else {
            return nil
        }
    }

    /**
    Returns true if the date corresponding to the day and the *largest/latest* time in times has passed this week.
    "This week" is determined by getting the next occurence of the date and seeing if it is after the day of the
    week new matches are assigned.

    If this `DaySchedule` doesn't correspond to a day, is `false`
    */
    static func scheduleHasPassed(day: String, times: [Float]) -> Bool {
        let nextSunday = Time.next(.sunday, at: 0)
        if let matchDate = Time.next(day: day, times: times) {
            return matchDate >= nextSunday
        } else {
            return false
        }
    }

}

// MARK: Helper Functinos
extension Time {

    /**
    Converts a float time to 2 integers representing hours and minutes.
    Only returns either on the hour times or half hours

    # Example:
    time = 0 -> (0, 30) (for 12:00 AM)
    time = 1 -> (1, 0) (for 1:00 AM)
    time = 13.5 -> (13, 30) (for 1:30 PM)
    time = 23.5 -> (23, 30) (for 11:30 PM)
    */
    private static func floatTimeToHoursMinutes(time: Float) -> (hours: Int, minutes: Int) {
        let hours = Int(time) == 0 ? 12 : Int(time)
        let minutes = time.rounded() > time ? 30 : 0
        return (hours, minutes)
    }

    /**
    Returns the next or previous `weekday` with a time based on `time`
    The search for the weekday includes today.
    # Example:
    If today is Monday 3:00 PM, `getWeekday(.forward, .sunday, 2)` returns next sunday (6 days from now) at 2:00 AM
    If today is Sunday 5:00 PM, `getWeekday(.forward, .sunday, 18)` returns **today** at 6:00 PM

    If today is Tuesday 3:00 PM, `getWeekday(.backward, .sunday, 2)` returns the previous sunday (2 days ago) at 2:00 AM
    If today is Sunday 5:00 PM, `getWeekday(.backward, .sunday, 13)` returns **today** at 1:00 PM
    */
    private static func getWeekday(searchDirection: Calendar.SearchDirection, weekday: Weekday, time: Float) -> Date {
        // Get the index of the `weekday`
        // Set today to have time specified by `time`
        let rightNow = Date()
        let hoursMinutes = Time.floatTimeToHoursMinutes(time: time)
        guard let todayWithTime = Time.calendar.date(
            bySettingHour: hoursMinutes.hours,
            minute: hoursMinutes.minutes,
            second: 0,
            of: rightNow
        ) else {
            print("""
            A date could not be found that matches the components using the current Calendar:
            calendar: \(Time.calendar)
            hours: \(hoursMinutes.hours)
            minutes: \(hoursMinutes.minutes)
            base date: \(rightNow)
            Returning right now as Date
            """)
            return Date()
        }

        // Depending on the search direction and time, the next/previous day might be today with a different time
        let df = DateFormatter()
        df.timeZone = .current
        df.dateFormat = "(MM-dd) HH:mm"

        if weekday.calendarIndex == Time.calendar.component(.weekday, from: todayWithTime) &&
            ((searchDirection == .forward && todayWithTime > rightNow) ||
            (searchDirection == .backward && todayWithTime < rightNow)) {
            return todayWithTime
        }

        // Move date to the next/previous weekday
        var nextDateComponent = Time.calendar.dateComponents([.hour, .minute], from: todayWithTime)
        nextDateComponent.weekday = weekday.calendarIndex

        guard let date = Time.calendar.nextDate(
            after: rightNow,
            matching: nextDateComponent,
            matchingPolicy: .nextTime,
            direction: searchDirection
        ) else {
            print("""
            A date could not be found that matches the components using the current Calendar:
            calendar: \(Time.calendar)
            dateComponents: \(nextDateComponent)
            matchingPolicy: \(Calendar.MatchingPolicy.nextTime)
            direction: \(searchDirection)
            Returning right now as Date
            """)
            return Date()
        }

        return date
    }

    /**
     Converts a string representation of a time to a float.
     If the time is a PM time, 12 hours are added.
     The time must be an hour or half-hour time.

     # Example:
     time = "9:00" -> 9.0
     time = "1:30" -> 13.5
     */
    static func stringTimeToFloat(time: String) -> Float {
        let timeList = time.components(separatedBy: ":")
        guard var hours = Float(timeList[0]) else { return 0.0 }
        if Time.isPm(time: time) && hours < 9.0 {
            hours += 12
        }
        guard let minutes = Float(timeList[1]) else { return 0.0 }
        return (hours + (minutes/60.0))
    }

    /**
     Converts a float time to a string representation of the time.
     The time must be an hour or half-hour time.

     # Example:
     time = 16.5 -> "4:30"
     time = 12.5 -> "12:30"
     */
    static func floatToStringTime(time: Float) -> String {
        let hoursMins = Time.floatTimeToHoursMinutes(time: time)
        var hoursInt = hoursMins.0
        if hoursInt > 12 {
            hoursInt -= 12
        }
        let hours = String(hoursInt)
        var mins = String(hoursMins.1)
        if mins.count == 1 {
            mins = "00"
        }
        return "\(hours):\(mins)"
    }

    /**
     Extracts the year, month, and day from a date, removing the time.
     */
    static func stripTimeOff(from originalDate: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: originalDate)
        let date = Calendar.current.date(from: components)
        return date ?? originalDate
    }

}
