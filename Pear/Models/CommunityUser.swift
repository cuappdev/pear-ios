//
//  CommunityUser.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 11/8/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct CommunityUser: Codable {

    let groups: [String]?
    let firstName: String?
    let googleID: String?
    let graduationYear: String?
    let hometown: String?
    let interests: [String]?
    let lastName: String?
    let major: String?
    let matches: [Match]?
    let netID: String?
    let profilePictureURL: String?
    let pronouns: String?
    let facebook: String?
    let instagram: String?

}
