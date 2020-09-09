//
//  FadedTableView.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 9/9/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

/// UITableView that fades its top and bottom to blend in with its background
class FadedTableView: UITableView {

    private let fadeColor: UIColor
    private let transparentColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)

    private let topFadeView = UIView()
    private let bottomFadeView = UIView()

    init(fadeColor: UIColor) {
        self.fadeColor = fadeColor
        super.init(frame: .zero, style: .plain)
        setupFadeEffect()
    }

    override init(frame: CGRect, style: UITableView.Style) {
        self.fadeColor = .clear
        super.init(frame: frame, style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFadeEffect() {
        applyFadeGradient(from: fadeColor, to: transparentColor)
        constrainFades()
    }

    private func applyFadeGradient(from startColor: UIColor, to endColor: UIColor) {
        let fadeColors = [startColor.cgColor, endColor.cgColor]

        let topLayer = CAGradientLayer()
        topLayer.frame = topFadeView.bounds
        topLayer.colors = fadeColors
        topLayer.locations = [0.0, 1.0]
        topFadeView.layer.insertSublayer(topLayer, at: 0)

        let bottomLayer = CAGradientLayer()
        bottomLayer.frame = bottomFadeView.bounds
        bottomLayer.colors = fadeColors.reversed()
        bottomLayer.locations = [0.0, 1.0]
        bottomFadeView.layer.insertSublayer(bottomLayer, at: 0)
    }

    private func constrainFades() {
        let topFadeHeight: CGFloat = 10
        let bottomFadeHeight: CGFloat = 26

        topFadeView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(topFadeHeight)
        }

        bottomFadeView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(bottomFadeHeight)
        }

    }
}
