
//  FadeWrapperView.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 10/16/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

enum FadePosition {
    case bottom
    case left
    case right
    case top
}

class FadeWrapperView<T: UIView>: UIView {

    // MARK: Public View Vars
    let view: T
    var fadeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 26, right: 0)
    var fadePositions: [FadePosition] = [.top, .bottom]

    // MARK: Private View Vars
    private let fadeColor: UIColor
    private let transparentColor: UIColor

    private let bottomFadeView = UIView()
    private let leftFadeView = UIView()
    private let rightFadeView = UIView()
    private let topFadeView = UIView()


    init(_ view: T, fadeColor: UIColor) {
        self.view = view
        self.fadeColor = fadeColor
        self.transparentColor = UIColor(cgColor: fadeColor.withAlphaComponent(0).cgColor)
        super.init(frame: .zero)
        setupViews()
    }

    private func setupViews() {
        addSubview(view)

        bottomFadeView.isUserInteractionEnabled = false
        leftFadeView.isUserInteractionEnabled = false
        rightFadeView.isUserInteractionEnabled = false
        topFadeView.isUserInteractionEnabled = false
        addSubview(bottomFadeView)
        addSubview(leftFadeView)
        addSubview(rightFadeView)
        addSubview(topFadeView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        setupConstraints()
        super.layoutSubviews()
        hideFadeViews()
        applyFadeGradients()
    }

    private func hideFadeViews() {
        bottomFadeView.isHidden = !fadePositions.contains(.bottom)
        leftFadeView.isHidden = !fadePositions.contains(.left)
        rightFadeView.isHidden = !fadePositions.contains(.right)
        topFadeView.isHidden = !fadePositions.contains(.top)
    }

    private func setupConstraints() {
        view.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        bottomFadeView.snp.remakeConstraints { make in
            make.bottom.leading.trailing.equalTo(view)
            make.height.equalTo(fadeInsets.bottom)
        }

        leftFadeView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalTo(view)
            make.width.equalTo(fadeInsets.left)
        }

        rightFadeView.snp.remakeConstraints { make in
            make.trailing.top.bottom.equalTo(view)
            make.width.equalTo(fadeInsets.right)
        }

        topFadeView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(fadeInsets.top)
        }
    }

    private func applyFadeGradients() {
        addGradient(to: bottomFadeView, direction: .bottom)
        addGradient(to: leftFadeView, direction: .left)
        addGradient(to: rightFadeView, direction: .right)
        addGradient(to: topFadeView, direction: .top)
    }

    private func addGradient(to view: UIView, direction: FadePosition) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [fadeColor.cgColor, transparentColor.cgColor]

        switch direction {
        case .bottom:
            gradientLayer.startPoint =  CGPoint(x: 0.5, y: 1)
            gradientLayer.endPoint =    CGPoint(x: 0.5, y: 0)
        case .left:
            gradientLayer.startPoint =  CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint =    CGPoint(x: 1, y: 0.5)
        case .right:
            gradientLayer.startPoint =  CGPoint(x: 1, y: 0.5)
            gradientLayer.endPoint =    CGPoint(x: 0, y: 0.5)
        case .top:
            gradientLayer.startPoint =  CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint =    CGPoint(x: 0.5, y: 1)
        }

        view.layer.addSublayer(gradientLayer)
    }

}
