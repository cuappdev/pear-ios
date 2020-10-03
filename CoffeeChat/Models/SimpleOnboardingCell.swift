//
//  SimpleOnboardingCell.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct SimpleOnboardingCell {

    let subtitle: String?
    let name: String

    init(name: String, subtitle: String?) {
        self.name = name
        self.subtitle = subtitle
    }

}
