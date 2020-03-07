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

    /// Returns custom vertical padding based using cubic ratio of screen size.
    func getShortenedCustomVertPadding(size: CGFloat) -> CGFloat {
        let quadHeight = pow(UIScreen.main.bounds.height, 3)
        let quadBase = pow(LayoutHelper.baseSize.height, 3)
        let ratio =  min(1, (quadHeight / quadBase))
        let heightSize = size * ratio
        return heightSize
    }

    /// Returns custom horizontal padding based on ratio of screen size.
    func getCustomHorizontalPadding(size: CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let ratio = width / LayoutHelper.baseSize.width
        print("ratio was \(ratio)!")
        let widthSize = size * ratio
        return widthSize
    }

}
