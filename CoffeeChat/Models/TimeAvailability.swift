//
//  TimeAvailability.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 11/28/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct TimeAvailability: Codable {

    let availabilities: [SubTimeAvailability]

    var schedule: [Schedule] {
        availabilities.map { Schedule(day: $0.day, times: $0.times) }
    }
}

struct SubTimeAvailability: Codable {

    let day: String
    let times: [Float]

}

