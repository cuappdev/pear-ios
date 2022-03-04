//
//  DynamicButton.swift
//  Pear
//
//  Created by Mathew Scullin on 3/4/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import Foundation
import UIKit

class DynamicButton: UIButton {
    override public var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .backgroundOrange : .inactiveGreen
            if isEnabled {
                backgroundColor = .backgroundOrange
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                layer.shadowOpacity = 0.15
                layer.shadowRadius = 2
            } else {
                backgroundColor = .inactiveGreen
                layer.shadowColor = .none
                layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                layer.shadowOpacity = 0
                layer.shadowRadius = 0
            }
        }
    }
}
