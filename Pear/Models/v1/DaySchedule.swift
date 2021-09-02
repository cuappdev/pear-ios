//
//  DaySchedule.swift
//  Pear
//
//  Created by Lucy Xu on 9/1/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation

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
