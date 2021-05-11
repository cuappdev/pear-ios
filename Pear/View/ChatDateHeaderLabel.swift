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
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.font = UIFont.getFont(.book, size: 14)
        self.textColor = .greenGray
        self.textAlignment = .center
    }

    func setDateString(section: Int, dateKeys: [Date]) {
        let date = dateKeys[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: date)
        self.text = dateString
    }

    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        return CGSize(width: originalContentSize.width + 10, height: originalContentSize.height + 6)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
