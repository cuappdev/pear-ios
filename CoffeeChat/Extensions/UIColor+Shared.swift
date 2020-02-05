//
//  UIColor+Shared.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/3/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

extension UIColor {

    // MARK: - Foreground
    static let textBlack = colorFromCode(0x000000)
    static let textGray = colorFromCode(0x3D3D3D)
    static let textLightGray = colorFromCode(0xADADAD)

    // MARK: - Background
    static let backgroundWhite = colorFromCode(0xFFFFFF)
    static let backgroundRed = colorFromCode(0xFFDEDE)
    static let backgroundLightGray = colorFromCode(0xEEEEEE)
    static let backgroundDarkGray = colorFromCode(0xC4C4C4)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

}
