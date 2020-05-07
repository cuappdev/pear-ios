//
//  SessionAuthorization.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct SessionAuthorization: Codable {

    let accessToken: String
    let active: Bool
    let refreshToken: String
    let sessionExpiration: String

}
