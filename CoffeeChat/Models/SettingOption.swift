//
//  SettingOption.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/10/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

class SettingOption {

    let hasSwitch: Bool
    let image: String
    var switchOn: Bool
    let text: String
    
    init(image: String, text: String, hasSwitch: Bool, switchOn: Bool) {
        self.image = image
        self.text = text
        self.hasSwitch = hasSwitch
        self.switchOn = switchOn
    }
}
