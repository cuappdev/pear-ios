//
//  LayoutHelper.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/20/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation
import UIKit

class LayoutHelper {

    static let shared = LayoutHelper()

    // Base width + height used in designs.
    static let baseSize = CGSize(width: 375, height: 812)

    private init() {}

    /// Returns custom vertical padding based on ratio of screen size.
    func getCustomVerticalPadding(size: CGFloat) -> CGFloat {
        let height = UIScreen.main.bounds.height
        let ratio = height / LayoutHelper.baseSize.height
        let heightSize = size * ratio
        return heightSize
    }

    /// Returns custom horizontal padding based on ratio of screen size.
    func getCustomHorizontalPadding(size: CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let ratio = width / LayoutHelper.baseSize.width
        let widthSize = size * ratio
        return widthSize
    }

}
