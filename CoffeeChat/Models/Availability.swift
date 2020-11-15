//
//  Availability.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 11/14/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

// TODO: Update struct after backend changes
struct Availability: Codable {

    let day: String
    let times: [Double]
    let users: [SubUser]

}
