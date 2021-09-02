//
//  Topic.swift
//  Pear
//
//  Created by Lucy Xu on 9/1/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation

protocol Topic {
    var name: String { get set }
    var id: Int { get set }
    var imgUrl: String { get set}
}

struct Interest: Topic, Codable {
    var id: Int
    var name: String
    let subtitle: String
    var imgUrl: String
}

struct Group: Topic, Codable {
    var id: Int
    var name: String
    var imgUrl: String
}
