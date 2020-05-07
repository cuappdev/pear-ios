//
//  Matching.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct Matching: Codable {

    let active: Bool
    let schedule: [DaySchedule]
    let users: [SubUser]

}
