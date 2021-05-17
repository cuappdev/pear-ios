//
//  ChatDateHeaderLabel.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class ChatDateHeaderLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        font = ._14CircularStdBook
        textColor = .greenGray
        textAlignment = .center
    }

    func setDateString(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: date)
        text = dateString
    }

    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        return CGSize(width: originalContentSize.width + 10, height: originalContentSize.height + 6)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
