//
//  UserSession.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 5/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct UserSession: Codable {

    let accessToken: String
    let username: String
    let firstName: String
    let lastName: String

}
