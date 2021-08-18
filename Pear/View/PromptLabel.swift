//
//  PromptLabel.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 8/18/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class PromptLabel: UILabel {

    let inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }

    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += inset.left + inset.right
        intrinsicContentSize.height += inset.top + inset.bottom
        return intrinsicContentSize
    }
}
