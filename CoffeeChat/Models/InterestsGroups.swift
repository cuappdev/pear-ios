//
//  InterestsGroups.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

enum InterestGroupEnum { case interest, group }

struct InterestsGroups {

    let name: String
    let type: InterestGroupEnum
    let categories: String?

    init(name: String, type: InterestGroupEnum, categories: String?) {
        self.name = name
        self.type = type
        self.categories = categories
    }

}
