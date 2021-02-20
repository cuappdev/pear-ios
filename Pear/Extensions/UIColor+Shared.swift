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
    static let darkGreen = colorFromCode(0x176027)
    static let greenGray = colorFromCode(0x5B7E58)
    static let metaData = colorFromCode(0x9E9E9E)
    static let primaryText = colorFromCode(0x212121)
    static let secondaryText = colorFromCode(0x616161)
    static let textGray = colorFromCode(0x3D3D3D)
    static let textGreen = colorFromCode(0x789F74)
    static let textLightGray = colorFromCode(0xADADAD)
    static let textRed = colorFromCode(0xD62C2C)
    static let wash = colorFromCode(0xf5f5f5)

    // MARK: - Background
    static let backgroundWhite = colorFromCode(0xFFFFFF)
    static let backgroundRed = colorFromCode(0xFFDEDE)
    static let backgroundDarkGreen = colorFromCode(0xACC5AC)
    static let backgroundGreen = colorFromCode(0xD2F2D1)
    static let backgroundLightGrayGreen = colorFromCode(0xE0ECE2)
    static let backgroundLightGreen = colorFromCode(0xF2F8E8)
    static let backgroundOrange = colorFromCode(0xFFAC5F)
    static let defaultGrey = colorFromCode(0xC4C4C4)
    static let inactiveGreen = colorFromCode(0x99A899)
    static let paleGreen = colorFromCode(0xE0ECE2)
    static let pearGreen = colorFromCode(0xABDD5B)
    static let pearYellow = colorFromCode(0xF0F9B3)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

}
