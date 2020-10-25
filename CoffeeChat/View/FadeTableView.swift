//
//  FadeTableView.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 9/9/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

/// UITableView that fades its top and bottom based on `fadeColor` to make the edges blend in with the background
class FadeTableView: UIView {

    let tableView = UITableView(frame: .zero, style: .plain)

    private let fadeColor: UIColor
    private let transparentColor: UIColor

    private let topFadeView = UIView()
    private let bottomFadeView = UIView()

    init(fadeColor: UIColor) {
        self.fadeColor = fadeColor
        self.transparentColor = UIColor(cgColor: fadeColor.withAlphaComponent(0).cgColor)
        super.init(frame: .zero)

        addSubview(tableView)
        addSubview(topFadeView)
        addSubview(bottomFadeView)
        setupTableView()
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

        addGradientToView(colors: fadeColors, view: topFadeView)
        addGradientToView(colors: fadeColors.reversed(), view: bottomFadeView)
    }

    private func addGradientToView(colors: [CGColor], view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupTableView() {
        tableView.clipsToBounds = true
        tableView.backgroundColor = .none
        tableView.allowsMultipleSelection = true
        tableView.bounces = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
    }

    private func setupConstraints() {
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
