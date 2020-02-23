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

    private init() {}

    /// Returns custom vertical padding based on ration of screen size.
    func setCustomVerticalPadding(size: CGFloat) -> CGFloat {
        let height = UIScreen.main.bounds.height
        let baseHeight: CGFloat = 812 // Base height used in designs.
        let heightSize = size * (height / baseHeight)
        return heightSize
    }

}
