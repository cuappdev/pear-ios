//
//  Response.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation
import FutureNova

struct Response<T: Codable>: Codable {

    var data: T
    var success: Bool

}
