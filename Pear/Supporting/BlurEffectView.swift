//
//  BlurEffectView.swift
//  Pear
//
//  Created by Vian Nguyen on 3/20/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class BlurEffectView: UIVisualEffectView {
    
    private let animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        frame = superview.bounds
        setupBlur()
    }
    
    private func setupBlur() {
        animator.stopAnimation(true)
        effect = nil
        
        animator.addAnimations { [weak self] in
            self?.effect = UIBlurEffect(style: .systemMaterialDark)
        }
        animator.fractionComplete = 0.07
    }
    
    deinit {
        animator.stopAnimation(true)
    }
}
