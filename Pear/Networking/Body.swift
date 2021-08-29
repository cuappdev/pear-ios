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
