//
//  LocationHeaderLabelView.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 11/24/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class LocationHeaderLabelView: UICollectionReusableView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = ._16CircularStdBook
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        label.text = text
    }

}
