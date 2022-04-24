//
//  DotView.swift
//  Pear
//
//  Created by Mathew Scullin on 4/20/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class DotView: UIView {
    
    // MARK: - Private Data Vars
    private var activeIndex: Int = 0
    private var circles: [UIView] = []
    
    init() {
        super.init(frame: .zero)
        for i in 0...3 {
            let circle = UIView()
            circle.backgroundColor = i == 0 ? .darkGreen : .inactiveGreen
            circle.clipsToBounds = true
            circle.layer.cornerRadius = 4
            addSubview(circle)
            circle.snp.makeConstraints { make in
                make.size.equalTo(8)
                make.top.equalToSuperview()
                make.leading.equalToSuperview().offset(i*16)
            }
            circles.append(circle)
        }
    }
    
    func updateIndex(newIndex: Int) {
        if newIndex >= 0 && newIndex <= 3 {
            circles[newIndex].backgroundColor = .darkGreen
            circles[activeIndex].backgroundColor = .inactiveGreen
            activeIndex = newIndex
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
