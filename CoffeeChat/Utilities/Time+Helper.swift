//
//  Time+Helper.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 4/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

enum Weekday: String, CaseIterable {

    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"

    var calendarIndex: Int {
        Self.allCases.firstIndex(of: self)! + 1
    }
}

class Time {

    /// We only work with Gregorian Calendar times
    static let calendar = Calendar(identifier: .gregorian)

    /// Day of the week matches are first assigned
    static let matchDay: Weekday = .sunday

    static let amTimes = ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30"]
    static let pmTimes = [
        "12:00", "12:30", "1:00", "1:30", "2:00", "2:30",
        "3:00", "3:30", "4:00", "4:30", "5:00", "5:30",
        "6:00", "6:30", "7:00", "7:30", "8:00", "8:30"
    ]

    /// Returns the number of days its been since matches have been assigned
    static var daysSinceMatching: Int {
        let lastSunday = getWeekday(searchDirection: .backward, weekday: .sunday, time: 0)
        let today = Date()
        return Time.calendar.dateComponents([.day], from: lastSunday, to: today).day ?? 0
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
        let hours = Int(time)
        let minutes = time.rounded() > time ? 30 : 0
        return (hours, minutes)
    }

    private static func getWeekDaysInEnglish() -> [String] {
        Time.calendar.weekdaySymbols
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
        if weekday.calendarIndex == Time.calendar.component(.weekday, from: rightNow) &&
            (searchDirection == .forward && todayWithTime > rightNow ||
            searchDirection == .backward && todayWithTime < rightNow)
        {
            return todayWithTime
        }

        // Move date to the next/previous weekday
        var nextDateComponent = Time.calendar.dateComponents([.hour, .minute, .second], from: todayWithTime)
        nextDateComponent.weekday = weekday.calendarIndex

        guard let date = Time.calendar.nextDate(
            after: todayWithTime,
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
            print("!!!!!")
            return Date()
        }

        return date
    }

}
