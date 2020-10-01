//
//  SimpleOnboardingCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

enum SimpleOnboardingCellType { case interest, normal }

struct SimpleOnboardingCell {

    let categories: String?
    let name: String
    let type: SimpleOnboardingCellType

    init(name: String, type: SimpleOnboardingCellType, categories: String?) {
        self.name = name
        self.type = type
        self.categories = categories
    }

}
