//
//  TimeCollectionViewCell.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/24/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {
    
    private let label = UILabel()
    
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
        }
        else {
            label.textColor = .textBlack
            contentView.layer.cornerRadius = 10
            contentView.backgroundColor = .white
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            layer.shadowOpacity = 0.15
            layer.shadowRadius = 2
        }
    }
    
    override var isSelected: Bool {
        didSet {
            // make sure first cell can't select
            super.isSelected = isSelected
            if isSelected {
                contentView.backgroundColor = .pearGreen
            } else {
                contentView.backgroundColor = .white
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
