//
//  Matching.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct Match: Codable {

    let matchID: String
    let status: String
    let meetingTime: Float
    let users: [String]
    let availibilities: TimeAvailability

}
