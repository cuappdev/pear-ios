//
//  InstagramResponse.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/14/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation

struct InstagramTestUser: Codable {
    var access_token: String
    var user_id: Int
}

struct InstagramUser: Codable {
    var id: String
    var username: String
}
