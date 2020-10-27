//
//  UIFont+Shared.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/12/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

enum Fonts {

    case book, medium, bold

    enum Circular {

        struct Standard {
            static let book = "CircularStd-Book"
            static let medium = "CircularStd-Medium"
            static let bold = "CircularStd-Bold"
        }
    }
}

extension UIFont {

    static let _10CircularStdBook = UIFont(name: "CircularStd-Book", size: 10)
    static let _12CircularStdBook = UIFont(name: "CircularStd-Book", size: 12)
    static let _16CircularStdBook = UIFont(name: "CircularStd-Book", size: 16)
    static let _20CircularStdBook = UIFont(name: "CircularStd-Book", size: 20)
    static let _24CircularStdBook = UIFont(name: "CircularStd-Book", size: 24)

    static let _12CircularStdMedium = UIFont(name: "CircularStd-Medium", size: 12)
    static let _16CircularStdMedium = UIFont(name: "CircularStd-Medium", size: 16)
    static let _20CircularStdMedium = UIFont(name: "CircularStd-Medium", size: 20)
    static let _24CircularStdMedium = UIFont(name: "CircularStd-Medium", size: 24)

    static let _20CircularStdBold = UIFont(name: "CircularStd-Bold", size: 20)

    /// Generate fonts for app usage
    static func getFont(_ name: Fonts, size: CGFloat) -> UIFont {
        var fontString: String
        switch name {
        case .book:
            fontString = Fonts.Circular.Standard.book
        case .medium:
            fontString = Fonts.Circular.Standard.medium
        case .bold:
            fontString = Fonts.Circular.Standard.bold
        }
        return UIFont(name: fontString, size: size)!
    }
}
