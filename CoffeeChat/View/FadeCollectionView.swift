//
//  FadeCollectionView.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 10/15/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

// TODO make a fade variant of this
class FadeCollectionView: UIView {

    let collectionView: UICollectionView

    private let fadeColor: UIColor
    private let transparentColor: UIColor

    private let topFadeView = UIView()
    private let bottomFadeView = UIView()

    private let fadePosition: FadePosition

    init(collectionViewLayout: UICollectionViewLayout, fadeColor: UIColor, fadePosition: FadePosition) {
        self.fadeColor = fadeColor
        self.transparentColor = UIColor(cgColor: fadeColor.withAlphaComponent(0).cgColor)
        self.fadePosition = fadePosition
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(frame: .zero)

        addSubview(collectionView)
        addSubview(topFadeView)
        addSubview(bottomFadeView)
        setupViews()
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

    private func setupViews() {
        collectionView.backgroundColor = .clear

        topFadeView.isHidden = fadePosition == .bottom
        bottomFadeView.isHidden = fadePosition == .top
        print("top hidden? \(topFadeView.isHidden) , bottom hidden: \(bottomFadeView.isHidden)")
    }

    private func setupConstraints() {
        let topFadeHeight: CGFloat = 10
        let bottomFadeHeight: CGFloat = 44

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topFadeView.snp.makeConstraints { make in
            make.top.leading.trailing.width.equalTo(collectionView)
            make.height.equalTo(topFadeHeight)
        }

        bottomFadeView.snp.makeConstraints { make in
            make.bottom.leading.trailing.width.equalTo(collectionView)
            make.height.equalTo(bottomFadeHeight)
        }
    }

}
