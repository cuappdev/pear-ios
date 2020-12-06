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
    let availabilities: TimeAvailability

    /**
        Returns the netid of the person the user is paired with.
        Is `nil` if all netIDs match the user or was unable to retrieve the user's netID from UserDefaults
    */
    var pair: String? {
        let userNetID = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId)
        if let userNetID = userNetID {
            return (users.filter { $0 != userNetID }).first
        }
        return nil
    }

}
