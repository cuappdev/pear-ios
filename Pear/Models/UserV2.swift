//
//  UserV2.swift
//  Pear
//
//  Created by Lucy Xu on 5/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

struct UserV2: Codable {

    let id: Int
    let netId: String
    let firstName: String
    let lastName: String
    let hometown: String?
    let profilePicUrl: String
    let facebookUrl: String?
    let instagramUsername: String?
//    let major: String
    let graduationYear: String?
//    let goals: [String]
//    let talkingPoints: [String]
//    let matches: [Int]
//    let availabilities: [String]
//    let locations: [LocationV2]
//    let interests: [InterestV2]
//    let groups: [GroupV2]

}

struct LocationV2: Codable {
    let id: String
    let name: String
    let area: String
}

struct InterestV2: Codable {
    let id: String
    let name: String
    let subtitle: String
    let imgUrl: String
}

struct GroupV2: Codable {
    let id: String
    let name: String
    let imgUrl: String
}

struct TalkingPointV2: Codable {
    let type: String
    let id: String
    let name: String
    let subtitle: String?
    let imgUrl: String
}
