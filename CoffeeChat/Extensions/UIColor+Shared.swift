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
    static let textDarkGray = colorFromCode(0x9E9E9E)
    static let textLightGray = colorFromCode(0xADADAD)
    static let textGreen = colorFromCode(0x789F74)
    static let textRed = colorFromCode(0xD62C2C)

    // MARK: - Background
    static let backgroundWhite = colorFromCode(0xFFFFFF)
    static let backgroundRed = colorFromCode(0xFFDEDE)
    static let backgroundLightGray = colorFromCode(0xEEEEEE)
    static let backgroundDarkGray = colorFromCode(0xC4C4C4)
    static let backgroundLightGreen = colorFromCode(0xF2F8E8)
    static let backgroundGreen = colorFromCode(0xD2F2D1)
    static let backgroundDarkGreen = colorFromCode(0xACC5AC)
    static let backgroundGrayGreen = colorFromCode(0x99A899)
    static let backgroundOrange = colorFromCode(0xFFAC5F)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

}
