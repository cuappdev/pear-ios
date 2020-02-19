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
    private var classSearchFields: [String] = []
    private let pronounSearchFields = ["She/Her/Hers", "He/Him/His", "They/Them/Theirs"]
    // TODO: Update with networking values from backend
    private let hometownSearchFields = ["Boston, MA", "New York, NY", "Washington, DC", "Sacramento, CA", "Ithaca, NY"]
    private let majorSearchFields = ["Computer Science", "Economics", "Psychology", "English", "Government"]

    private var fieldsEntered: [Bool] = [false, false, false, false]
    private var allFieldsEntered: Bool = false

    // MARK: - Private View Vars
    private let greetingLabel = UILabel()
    private let helloLabel = UILabel()
    private var classDropdownView: OnboardingDropdownView!
    private var majorSearchView: OnboardingSearchView!
    private var hometownSearchView: OnboardingSearchView!
    private let nextButton = UIButton()
    private var pronounsDropdownView: OnboardingDropdownView!
    private let pronounsTableView = UITableView()
    private var onboardingSearchViews: [OnboardingSearchView] = []
    private var onboardingDropdownViews: [OnboardingDropdownView] = []

    // MARK: - Private Constants
    private let fieldsCornerRadius: CGFloat = 8
    private let textFieldHeight: CGFloat = 49

    init(delegate: OnboardingPageDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .backgroundLightGreen

        helloLabel.text = "Hi \(userDefaults.string(forKey: "userFirstName") ?? "user")!"
        helloLabel.textColor = .textBlack
        helloLabel.font = ._24CircularStdMedium
        view.addSubview(helloLabel)

        greetingLabel.text = "Let's get to know you better."
        greetingLabel.textColor = .textBlack
        greetingLabel.font = ._24CircularStdMedium
        view.addSubview(greetingLabel)

        let currentYear = Calendar.current.component(.year, from: Date())
        for year in currentYear...currentYear+4 {
            classSearchFields.append("\(year)")
        }

        classDropdownView = OnboardingDropdownView(delegate: self, placeholder: "Class of...", tableData: classSearchFields)
        classDropdownView.tag = 0
        view.addSubview(classDropdownView)

        majorSearchView = OnboardingSearchView(delegate: self, placeholder: "Major", tableData: majorSearchFields)
        majorSearchView.tag = 1
        view.addSubview(majorSearchView)

        hometownSearchView = OnboardingSearchView(delegate: self, placeholder: "Hometown", tableData: hometownSearchFields)
        hometownSearchView.tag = 2
        view.addSubview(hometownSearchView)

        pronounsDropdownView = OnboardingDropdownView(delegate: self, placeholder: "Pronouns", tableData: pronounSearchFields)
        pronounsDropdownView.tag = 3
        view.addSubview(pronounsDropdownView)

        onboardingSearchViews = [majorSearchView, hometownSearchView]
        onboardingDropdownViews = [classDropdownView, pronounsDropdownView]

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBook
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = 26
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        setUpConstraints()
    }

    @objc private func nextButtonPressed() {
        if allFieldsEntered {
            delegate?.nextPage(index: 1)
        }
    }

//    private func setCustomFontSize(size: CGFloat) -> CGFloat {
//        let width = UIScreen.main.bounds.width
//        let baseWidth: CGFloat = 375
//        let fontSize = size * (width / baseWidth)
//        return fontSize
//    }

    func setCustomVerticalPadding(size: CGFloat) -> CGFloat {
        let height = UIScreen.main.bounds.height
        let baseHeight: CGFloat = 812
        let heightSize = size * (height / baseHeight)
        return heightSize
    }

    private func setUpConstraints() {
        let fieldTopPadding: CGFloat = setCustomVerticalPadding(size: 60)
        let helloLabelHeight: CGFloat = 30
        let helloLabelPadding: CGFloat = setCustomVerticalPadding(size: 100)
        let nextBottomPadding: CGFloat = setCustomVerticalPadding(size: 90)
        let nextButtonSize = CGSize(width: 225, height: 54)
        let textFieldSidePadding: CGFloat = 40
        let textFieldTopPadding: CGFloat = 20
        let textFieldTotalPadding: CGFloat = textFieldHeight + textFieldTopPadding

        helloLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(helloLabelHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(helloLabelPadding)
        }

        greetingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(helloLabel.snp.bottom).offset(10)
        }

        classDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(greetingLabel.snp.bottom).offset(fieldTopPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        majorSearchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(classDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        hometownSearchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(majorSearchView.snp.top).offset(textFieldTotalPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        pronounsDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hometownSearchView.snp.top).offset(textFieldTotalPadding)
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

extension DemographicsViewController: OnboardingSearchViewDelegate {
    func updateSelectedFields(fieldTag: Int, selected: Bool) {
        fieldsEntered[fieldTag] = selected
        var count = 0
        for field in fieldsEntered {
            if field {
                count = count + 1
            }
        }
        if (count==4) {
            allFieldsEntered = true
            nextButton.backgroundColor = .backgroundOrange
        } else {
            allFieldsEntered = false
            nextButton.backgroundColor = .inactiveGreen
        }
    }

    func updateSearchViewHeight(searchView: UIView, height: CGFloat) {
        view.bringSubviewToFront(searchView)
        searchView.snp.updateConstraints{ make in
            make.height.equalTo(textFieldHeight + height)
        }
    }

    func bringSearchViewToFront(searchView: UIView, height: CGFloat, dropdown: Bool) {
        view.bringSubviewToFront(searchView)

        if dropdown {
            self.view.endEditing(true)
        }

        searchView.snp.updateConstraints{ make in
            make.height.equalTo(49+300)
        }

        onboardingSearchViews.forEach {
            if !$0.isEqual(searchView) {
                view.sendSubviewToBack($0)
                $0.collapseTableView()
                $0.snp.updateConstraints{ make in
                    make.height.equalTo(textFieldHeight)
                }
            }
        }

        onboardingDropdownViews.forEach {
            if !$0.isEqual(searchView) {
                view.sendSubviewToBack($0)
                $0.collapseTableView()
                $0.snp.updateConstraints{ make in
                    make.height.equalTo(textFieldHeight)
                }
            }
        }
    }

    func sendSearchViewToBack(searchView: UIView) {
        view.sendSubviewToBack(searchView)
        searchView.snp.updateConstraints{ make in
            make.height.equalTo(textFieldHeight)
        }
        view.endEditing(true)
    }
}
