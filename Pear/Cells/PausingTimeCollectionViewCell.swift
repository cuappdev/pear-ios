//
//  PausingTimeCollectionViewCell.swift
//  Pear
//
//  Created by Vian Nguyen on 3/1/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class PausingTimeCollectionViewCell: UICollectionViewCell {
    
    private let label = UILabel()
    static let reuseIdentifier = "PausingTimeReuseIdentifier"

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .pearGreen : .white
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = ._16CircularStdBook
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func configure(for text: String, isHeader: Bool) {
        label.text = text
        if isHeader {
            label.textColor = .greenGray
            contentView.backgroundColor = .clear
            layer.shadowColor = .none
            layer.shadowOffset = .zero
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
        } else {
            label.textColor = .black
            contentView.layer.cornerRadius = 10
            contentView.backgroundColor = .white
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            layer.shadowOpacity = 0.15
            layer.shadowRadius = 2
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
