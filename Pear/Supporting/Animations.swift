//
//  Animations.swift
//  Pear
//
//  Created by Vian Nguyen on 3/21/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class Animations {
    
    static let blurEffectView = BlurEffectView()
    
    static func presentPopUpView(superView: UIView, popUpView: UIView) {
        blurEffectView.frame = superView.frame
        
        superView.addSubview(blurEffectView)
        superView.addSubview(popUpView)
        
        popUpView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(popUpView.frame.height)
            make.width.equalTo(popUpView.frame.width)
        }
                
        UIView.animate(withDuration: 0.3, animations: {
            popUpView.transform = .init(scaleX: 1.5, y: 1.5)
            popUpView.alpha = 1
            popUpView.transform = .identity
            Animations.blurEffectView.alpha = 1
        })
    }
    
    static func removePopUpView(popUpView: UIView) {
        UIView.animate(withDuration: 0.15) {
            popUpView.alpha = 0
            Animations.blurEffectView.alpha = 0
        } completion: { _ in
            popUpView.removeFromSuperview()
        }
    }
    
}


