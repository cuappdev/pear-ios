//
//  GroupsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/9/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class GroupsViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let clubLabel = UILabel()
    private let greetingLabel = UILabel()
    private let nextButton = UIButton()

    init(delegate: OnboardingPageDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundWhite

        clubLabel.text = "What clubs are you in?"
        clubLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(clubLabel)

        nextButton.setTitle("Get started!", for: .normal)
        nextButton.layer.cornerRadius = 27
        nextButton.backgroundColor = .backgroundLightGray
        nextButton.setTitleColor(.textBlack, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        backButton.titleLabel?.font = .systemFont(ofSize: 16)
        backButton.setTitle("Go back", for: .normal)
        backButton.setTitleColor(.textLightGray, for: .normal)
        backButton.backgroundColor = .none
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        setupConstraints()
    }

    private func setupConstraints() {

        let backBottomPadding: CGFloat = 49
        let backButtonSize = CGSize(width: 62, height: 20)
        let nextButtonSize = CGSize(width: 225, height: 54)
        let nextBottomPadding: CGFloat = 21
        let titleHeight: CGFloat = 30
        let titleSpacing: CGFloat = 100

        clubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleSpacing)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backButton.snp.top).offset(-nextBottomPadding)
        }

        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(backBottomPadding)
        }
    }

    @objc func nextButtonPressed() {
        print("Next button pressed.")
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 1)
    }

}
