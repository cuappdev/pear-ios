//
//  Response.swift
//  Pear
//
//  Created by Lucy Xu on 2/20/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation
import FutureNova

struct Response<T: Codable>: Codable {

    let data: T
    let success: Bool

}

struct SuccessResponse: Codable {

    let success: Bool

}
