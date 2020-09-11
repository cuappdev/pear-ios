//
//  FadedTableView.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 9/9/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

/// UITableView that fades its top and bottom to blend in with its background
class FadeTableView: UIView {

    let tableView = UITableView(frame: .zero, style: .plain)

    private let fadeColor: UIColor
    private let transparentColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)
    private let topFadeView = UIView()
    private let bottomFadeView = UIView()

    init(fadeColor: UIColor) {
        self.fadeColor = fadeColor
        super.init(frame: .zero)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyFadeGradient()
    }

    private func applyFadeGradient() {
        let fadeColors = [fadeColor.cgColor, transparentColor.cgColor]

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

    private func setupConstraints() {
        addSubview(tableView)
        addSubview(topFadeView)
        addSubview(bottomFadeView)

        let topFadeHeight: CGFloat = 10
        let bottomFadeHeight: CGFloat = 26

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topFadeView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(tableView)
            make.width.equalTo(tableView)
            make.height.equalTo(topFadeHeight)
        }

        bottomFadeView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(tableView)
            make.width.equalTo(tableView)
            make.height.equalTo(bottomFadeHeight)
        }
    }
}

