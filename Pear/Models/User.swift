//
//  User.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {

    let netID: String
    let firstName: String
    let lastName: String
    let hometown: String
    let profilePictureURL: String
    let major: String
    let graduationYear: String
    let pronouns: String
    let interests: [String]
    let groups: [String]
    let facebook: String?
    let instagram: String?

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.netID == rhs.netID
    }

}
