//
//  SettingOption.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/10/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

class SettingOption {
    let image: String
    let text: String
    let hasSwitch: Bool
    var switchOn: Bool
    
    init(image: String, text: String, hasSwitch: Bool, switchOn: Bool) {
        self.image = image
        self.text = text
        self.hasSwitch = hasSwitch
        self.switchOn = switchOn
    }
}
