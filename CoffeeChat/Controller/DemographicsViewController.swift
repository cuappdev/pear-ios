//
//  DemographicsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/6/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class DemographicsViewController: UIViewController {

    private var delegate: OnboardingPageDelegate!
    private let userDefaults = UserDefaults.standard

//    private let helloMessage = "Hi \(userDefaults.data(forKey: Constants.UserDefaults.userFirstName))!"
    private let greetingMessage = "Let's get to know you better."
    private let greetingLabel = UILabel()
    private let helloLabel = UILabel()

    private let classTextField = UITextField()
    private let majorSearchBar = UISearchBar()
    private let hometownSearchBar = UISearchBar()
    private let pronounsTextField = UITextField()
    private let nextButton = UIButton()

    init(delegate: OnboardingPageDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        // lucy - double check force unwrap
        helloLabel.text = "Hi \(userDefaults.string(forKey: Constants.UserDefaults.userFirstName)!)!"
        helloLabel.textColor = .textBlack
        helloLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(helloLabel)

        greetingLabel.text = greetingMessage
        greetingLabel.textColor = .textBlack
        greetingLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(greetingLabel)

        classTextField.backgroundColor = .backgroundLightGray
        classTextField.placeholder = "Class of..."
        classTextField.keyboardType = .decimalPad
        // lucy - double check placeholders
        // lucy - double check comment styling and user defaults
        classTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        classTextField.leftViewMode = .always
        classTextField.layer.cornerRadius = 8
        view.addSubview(classTextField)

        majorSearchBar.backgroundColor = .backgroundLightGray
        majorSearchBar.backgroundImage = UIImage() // to get rid of the two lines in search bar
        let majorTextField = majorSearchBar.value(forKey: "searchField") as? UITextField
        majorTextField?.backgroundColor = .backgroundLightGray
        majorTextField?.placeholder = "Major"
        majorTextField?.clearButtonMode = .never
        majorSearchBar.setImage(UIImage(), for: .search, state: .normal) // hides the search icon bar
        majorSearchBar.layer.cornerRadius = 8
        majorSearchBar.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        majorSearchBar.showsCancelButton = false
        view.addSubview(majorSearchBar)

        hometownSearchBar.backgroundColor = .backgroundLightGray
        hometownSearchBar.backgroundImage = UIImage() // to get rid of the two lines in search bar
        let hometownSearchField = hometownSearchBar.value(forKey: "searchField") as? UITextField
        hometownSearchField?.backgroundColor = .backgroundLightGray
        hometownSearchField?.placeholder = "Hometown"
        hometownSearchField?.clearButtonMode = .never
        hometownSearchBar.setImage(UIImage(), for: .search, state: .normal) // hides the search icon bar
        hometownSearchBar.layer.cornerRadius = 8
        hometownSearchBar.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        hometownSearchBar.showsCancelButton = false
        view.addSubview(hometownSearchBar)

        pronounsTextField.backgroundColor = .backgroundLightGray
        pronounsTextField.placeholder = "Pronouns"
        pronounsTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        pronounsTextField.leftViewMode = .always
        pronounsTextField.layer.cornerRadius = 8
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
        print("Next")
        delegate.nextPage(index: 1)
    }

    func setUpConstraints() {

        helloLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(98)
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
            make.bottom.equalToSuperview().offset(-92)
            make.width.equalTo(225)
            make.height.equalTo(54)
            make.centerX.equalToSuperview()
        }
    }
}
