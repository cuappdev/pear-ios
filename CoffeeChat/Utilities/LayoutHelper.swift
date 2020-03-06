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
        let ratio = min(1, (height / LayoutHelper.baseSize.height))
        let heightSize = size * ratio
        return heightSize
    }

    /// Returns custom vertical padding based using cubic ratio of screen size.
    func getShortenedCustomVertPadding(size: CGFloat) -> CGFloat {
        print("screen vert is: \(UIScreen.main.bounds.height)")
        print("screen horiz is: \(UIScreen.main.bounds.width)")
        print("mockup thinks its height is... : \(LayoutHelper.baseSize.height)")
        print("mockup thinks its width is... : \(LayoutHelper.baseSize.width)")
        let quadHeight = pow(UIScreen.main.bounds.height, 3)
        let quadBase = pow(LayoutHelper.baseSize.height, 3)
        let ratio =  min(1, (quadHeight / quadBase))
        let heightSize = size * ratio
        return heightSize
    }

    /// Returns custom horizontal padding based on ratio of screen size.
    func getCustomHoriztonalPadding(size: CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let ratio = min(1, (width / LayoutHelper.baseSize.width))
        let widthSize = size * ratio
        return widthSize
    }

}
