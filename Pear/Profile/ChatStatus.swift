//
//  ChatStatus.swift
//  Pear
//
//  Created by Lucy Xu on 3/14/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

enum ChatStatus {
    /// No one has reached out yet
    case planning
    /// No one has reached out in 3 days
    case noResponses

    /// User already reached out and is waiting on `SubUser`
    case waitingOn(User)
    /// `SubUser` already reached out, and user is responding
    case respondingTo(User)

    /// The chat date has passed
    case finished
    /// The chat has been cancelled with `SubUser`
    case cancelled(User)

    /// Chat between the User and `SubUser` has been scheduled and is coming up on `Date`
    case chatScheduled(User, Date)

    static func forMatch(match: Match, pair: User) -> ChatStatus {
//        if match.allAvailibilitiesPassed {
//            return .finished
//        }

        switch match.status {
        case Constants.Match.created:
            return Time.daysSinceMatching >= 3 ? .noResponses : .planning

        case Constants.Match.proposed:
            return userAlreadyReachedOut(to: match) ? .waitingOn(pair) : .respondingTo(pair)

        case Constants.Match.cancelled:
            return .cancelled(pair)

        case Constants.Match.active:
            guard let availability = match.availabilities.first else {
                print("match's timeAvailability has no availabilities, but is active. Returning finished instead")
                return .finished
            }
            guard let date = Time.next(day: availability.day, times: availability.times) else {
                print("Couldn't convert match's timeAvailability to a Date, returning finished instead")
                return .finished
            }
            return Time.scheduleHasPassed(day: availability.day, times: availability.times)
                ? .finished
                : .chatScheduled(pair, date)

        case Constants.Match.inactive:
            return .finished

        default:
            print("Match has an invalid status; Using planning instead (match: \(match))")
            return .planning
        }
    }
}

/// If the local stored matchID matches the current match from backend, then the user has already reached out
func userAlreadyReachedOut(to match: Match) -> Bool {
    let matchIDLastReachedOut = UserDefaults.standard.string(forKey: Constants.UserDefaults.matchIDLastReachedOut)
    return matchIDLastReachedOut == match.matchID
}
