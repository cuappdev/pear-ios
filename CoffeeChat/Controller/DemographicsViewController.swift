//
//  DemographicsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/6/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class DemographicsViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?
    private let userDefaults = UserDefaults.standard

    // MARK: - Private View Vars
    private let classTextField = UITextField()
    private let greetingLabel = UILabel()
    private let helloLabel = UILabel()
    private let hometownSearchBar = UISearchBar()
    private let majorSearchBar = UISearchBar()
    private let nextButton = UIButton()
    private let pronounsTextField = UITextField()

    // MARK: - Private Constants
    private let fieldsCornerRadius: CGFloat = 8

    init(delegate: OnboardingPageDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        helloLabel.text = "Hi \(userDefaults.string(forKey: "userFirstName") ?? "user")!"
        helloLabel.textColor = .textBlack
        helloLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(helloLabel)

        greetingLabel.text = "Let's get to know you better."
        greetingLabel.textColor = .textBlack
        greetingLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(greetingLabel)

        classTextField.backgroundColor = .backgroundLightGray
        classTextField.attributedPlaceholder = NSAttributedString(string: "Class of...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray])
        classTextField.keyboardType = .decimalPad
        classTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        classTextField.leftViewMode = .always
        classTextField.layer.cornerRadius = fieldsCornerRadius
        view.addSubview(classTextField)

        majorSearchBar.backgroundColor = .backgroundLightGray
        majorSearchBar.backgroundImage = UIImage()
        // majorSearchBar.delegate = self
        if let majorTextField = majorSearchBar.value(forKey: "searchField") as? UITextField {
            majorTextField.backgroundColor = .backgroundLightGray
            majorTextField.attributedPlaceholder = NSAttributedString(string: "Major", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray])
            majorTextField.clearButtonMode = .never
        }
        majorSearchBar.setImage(UIImage(), for: .search, state: .normal)
        majorSearchBar.layer.cornerRadius = fieldsCornerRadius
        majorSearchBar.searchTextPositionAdjustment = UIOffset(horizontal: -6, vertical: 0)
        majorSearchBar.showsCancelButton = false
        view.addSubview(majorSearchBar)

        hometownSearchBar.backgroundColor = .backgroundLightGray
        hometownSearchBar.backgroundImage = UIImage()
        // hometownSearchBar.delegate = self
        if let hometownSearchField = hometownSearchBar.value(forKey: "searchField") as? UITextField {
            hometownSearchField.backgroundColor = .backgroundLightGray
            hometownSearchField.attributedPlaceholder = NSAttributedString(string: "Hometown", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray])
            hometownSearchField.clearButtonMode = .never
        }
        hometownSearchBar.setImage(UIImage(), for: .search, state: .normal)
        hometownSearchBar.layer.cornerRadius = fieldsCornerRadius
        hometownSearchBar.searchTextPositionAdjustment = UIOffset(horizontal: -6, vertical: 0)
        hometownSearchBar.showsCancelButton = false
        view.addSubview(hometownSearchBar)

        pronounsTextField.backgroundColor = .backgroundLightGray
        pronounsTextField.attributedPlaceholder = NSAttributedString(string: "Pronouns", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray])
        pronounsTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        pronounsTextField.leftViewMode = .always
        pronounsTextField.layer.cornerRadius = fieldsCornerRadius
        view.addSubview(pronounsTextField)

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.textBlack, for: .normal)
        nextButton.backgroundColor = .backgroundLightGray
        nextButton.layer.cornerRadius = 26
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        setUpConstraints()
    }

    @objc func nextButtonPressed() {
        delegate?.nextPage(index: 1)
    }

    private func setUpConstraints() {
        let helloLabelHeight: CGFloat = 30
        let helloLabelSpacing: CGFloat = 100
        let nextBottomPadding: CGFloat = 90
        let nextButtonSize = CGSize(width: 225, height: 54)
        let textFieldSidePadding: CGFloat = 40
        let textFieldHeight: CGFloat = 49
        let textFieldTopPadding: CGFloat = 20

        helloLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(helloLabelHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(helloLabelSpacing)
        }

        greetingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(helloLabel.snp.bottom).offset(10)
        }

        classTextField.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(greetingLabel.snp.bottom).offset(149)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        majorSearchBar.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(classTextField.snp.bottom).offset(textFieldTopPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        hometownSearchBar.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(majorSearchBar.snp.bottom).offset(textFieldTopPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        pronounsTextField.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hometownSearchBar.snp.bottom).offset(textFieldTopPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextBottomPadding)
        }
    }
}
