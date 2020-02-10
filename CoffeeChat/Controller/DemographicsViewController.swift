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
    private var delegate: OnboardingPageDelegate!
    private let userDefaults = UserDefaults.standard

    // MARK: - Private View Vars
    private let greetingLabel = UILabel()
    private let helloLabel = UILabel()
    private let classTextField = UITextField()
    private let majorSearchBar = UISearchBar()
    private let hometownSearchBar = UISearchBar()
    private let pronounsTextField = UITextField()
    private let nextButton = UIButton()

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

        helloLabel.text = "Hi \(userDefaults.string(forKey: "userFirstName")!)!"
        helloLabel.textColor = .textBlack
        helloLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(helloLabel)

        greetingLabel.text = "Let's get to know you better."
        greetingLabel.textColor = .textBlack
        greetingLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(greetingLabel)

        classTextField.backgroundColor = .backgroundLightGray
//        classTextField.placeholder = "Class of..."
        classTextField.attributedPlaceholder = NSAttributedString(string: "Class of...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray])
        classTextField.keyboardType = .decimalPad
        classTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        classTextField.leftViewMode = .always
        classTextField.layer.cornerRadius = fieldsCornerRadius
        view.addSubview(classTextField)

        majorSearchBar.backgroundColor = .backgroundLightGray
        majorSearchBar.backgroundImage = UIImage()
        // majorSearchBar.delegate = self
        let majorTextField = majorSearchBar.value(forKey: "searchField") as? UITextField
        majorTextField?.backgroundColor = .backgroundLightGray
        majorTextField?.attributedPlaceholder = NSAttributedString(string: "Major", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray])
        majorTextField?.clearButtonMode = .never
        majorSearchBar.setImage(UIImage(), for: .search, state: .normal)
        majorSearchBar.layer.cornerRadius = fieldsCornerRadius
        majorSearchBar.searchTextPositionAdjustment = UIOffset(horizontal: -6, vertical: 0)
        majorSearchBar.showsCancelButton = false
        view.addSubview(majorSearchBar)

        hometownSearchBar.backgroundColor = .backgroundLightGray
        hometownSearchBar.backgroundImage = UIImage()
        // hometownSearchBar.delegate = self
        let hometownSearchField = hometownSearchBar.value(forKey: "searchField") as? UITextField
        hometownSearchField?.backgroundColor = .backgroundLightGray
        hometownSearchField?.attributedPlaceholder = NSAttributedString(string: "Hometown", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray])
        hometownSearchField?.clearButtonMode = .never
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
        delegate.nextPage(index: 1)
    }

    func setUpConstraints() {

        let helloHeight: CGFloat = 30
        let helloSpacing: CGFloat = 100
        let nextButtonSize = CGSize(width: 225, height: 54)

        helloLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(helloHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(helloSpacing)
        }

        greetingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(helloLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
        }

        classTextField.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(greetingLabel.snp.bottom).offset(149)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(49)
        }

        majorSearchBar.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(classTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(49)
        }

        hometownSearchBar.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(majorSearchBar.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(49)
        }

        pronounsTextField.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hometownSearchBar.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(49)
        }

        nextButton.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().offset(-130)
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
        }
    }
}
