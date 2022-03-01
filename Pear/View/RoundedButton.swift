//
//  RoundedButton.swift
//  Pear
//
//  Created by Vian Nguyen on 3/1/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    init(text: String) {
        setTitle(text, for: .normal
        setTitleColor(.white, for: .normal))
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    if self.isEnabled {
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
