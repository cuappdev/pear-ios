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
    private var classSearchFields: [String] = []
    private weak var delegate: OnboardingPageDelegate?
    private var fieldsEntered: [Bool] = [false, false, false, false] // Keep track of selection status of each field.
    private var fieldValues: [String: String] = [:] // Keep track of selected values
    // TODO: Update with networking values from backend
    private let hometownSearchFields = ["Boston, MA", "New York, NY", "Washington, DC", "Sacramento, CA", "Ithaca, NY"]
    private let majorSearchFields = ["Computer Science", "Economics", "Psychology", "English", "Government"]
    private let pronounSearchFields = ["She/Her/Hers", "He/Him/His", "They/Them/Theirs"]
    private let userDefaults = UserDefaults.standard

    // MARK: - Private View Vars
    private var activeDropdownView: UIView? // Keep track of currently active field
    private var classDropdownView: OnboardingSelectDropdownView!
    private let greetingLabel = UILabel()
    private var hometownDropdownView: OnboardingSearchDropdownView!
    private var majorDropdownView: OnboardingSearchDropdownView!
    private let nextButton = UIButton()
    private var pronounsDropdownView: OnboardingSelectDropdownView!
    private let titleLabel = UILabel()

    // MARK: - Private Constants
    private let fieldsCornerRadius: CGFloat = 8
    private let fieldMap = [
        Constants.UserDefaults.userGraduationYear,
        Constants.UserDefaults.userMajor,
        Constants.UserDefaults.userHometown,
        Constants.UserDefaults.userPronouns
    ]
    private let textFieldHeight: CGFloat = 49

    init(delegate: OnboardingPageDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true

        titleLabel.text = "Hi \(userDefaults.string(forKey: "userFirstName") ?? "user")!\nLet's get to know you better."
        titleLabel.textColor = .black
        titleLabel.font = ._24CircularStdMedium
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        // Renders the valid graduation years based on current year.
        let currentYear = Calendar.current.component(.year, from: Date())
        let gradYear = currentYear + 4 // Allow only current undergrads and fifth years
        classSearchFields = (currentYear...gradYear).map { "\($0)" }

        classDropdownView = OnboardingSelectDropdownView(delegate: self,
                                                         placeholder: "Class of...",
                                                         tableData: classSearchFields,
                                                         textTemplate: "Class of")
        classDropdownView.tag = 0 // Set tag to keep track of field selection status.
        view.addSubview(classDropdownView)

        majorDropdownView = OnboardingSearchDropdownView(delegate: self,
                                                         placeholder: "Major",
                                                         tableData: majorSearchFields)
        majorDropdownView.tag = 1 // Set tag to keep track of field selection status.
        view.addSubview(majorDropdownView)

        hometownDropdownView = OnboardingSearchDropdownView(delegate: self,
                                                            placeholder: "Hometown",
                                                            tableData: hometownSearchFields)
        hometownDropdownView.tag = 2 // Set tag to keep track of field selection status.
        view.addSubview(hometownDropdownView)

        pronounsDropdownView = OnboardingSelectDropdownView(delegate: self,
                                                            placeholder: "Pronouns",
                                                            tableData: pronounSearchFields, textTemplate: "")
        pronounsDropdownView.tag = 3 // Set tag to keep track of field selection status.
        view.addSubview(pronounsDropdownView)

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.isEnabled = false
        nextButton.layer.cornerRadius = 26
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        setUpConstraints()
    }

    @objc private func nextButtonPressed() {
        /// Save onboarding information to user defaults, for user creation later.
        let graduationYear = fieldValues[fieldMap[0]]!
        let major = fieldValues[fieldMap[1]]!
        let hometown = fieldValues[fieldMap[2]]!
        let pronouns = fieldValues[fieldMap[3]]!
        NetworkManager.shared.updateUserDemographics(graduationYear: graduationYear,
                                              major: major,
                                              hometown: hometown,
                                              pronouns: pronouns,
                                              picture: "").observe { ans in
                                                print(ans)
        }
        delegate?.nextPage(index: 1)
    }

    private func setUpConstraints() {
        let fieldTopPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 84)
        let textFieldSidePadding: CGFloat = 40
        let textFieldTotalPadding: CGFloat = textFieldHeight + 20

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(29)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }

        classDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(fieldTopPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        majorDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(classDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        hometownDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(majorDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        pronounsDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hometownDropdownView.snp.top).offset(textFieldTotalPadding)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }
    }

    private func updateFieldConstraints(fieldView: UIView, height: CGFloat) {
        fieldView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

extension DemographicsViewController: OnboardingDropdownViewDelegate {

    func updateSelectedFields(tag: Int, isSelected: Bool, valueSelected: String) {
        fieldsEntered[tag] = isSelected
        if isSelected { fieldValues[fieldMap[tag]] = valueSelected }
        let allFieldsEntered = !fieldsEntered.contains(false)
        nextButton.isEnabled = allFieldsEntered
        if nextButton.isEnabled {
            nextButton.backgroundColor = .backgroundOrange
            nextButton.layer.shadowColor = UIColor.black.cgColor
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            nextButton.layer.shadowOpacity = 0.15
            nextButton.layer.shadowRadius = 2
        } else {
            nextButton.backgroundColor = .inactiveGreen
            nextButton.layer.shadowColor = .none
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            nextButton.layer.shadowOpacity = 0
            nextButton.layer.shadowRadius = 0
        }
    }

    /// Resizes search view based on input to search field
    func updateDropdownViewHeight(dropdownView: UIView, height: CGFloat) {
        view.bringSubviewToFront(dropdownView)
        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight + height)
    }

    /// Brings field view to the front of the screen and handles keyboard interactions
    /// when switching from select dropdowns to search.
    func bringDropdownViewToFront(dropdownView: UIView, height: CGFloat, isSelect: Bool) {
        if let activeDropdownView = activeDropdownView as? OnboardingSearchDropdownView,
             activeDropdownView != dropdownView {
            view.sendSubviewToBack(activeDropdownView)
            updateFieldConstraints(fieldView: activeDropdownView, height: textFieldHeight)
            activeDropdownView.hideTableView()
            activeDropdownView.endEditing(true)
        } else if let activeDropdownView = activeDropdownView as? OnboardingSelectDropdownView,
            activeDropdownView != dropdownView {
            view.sendSubviewToBack(activeDropdownView)
            updateFieldConstraints(fieldView: activeDropdownView, height: textFieldHeight)
            activeDropdownView.hideTableView()
        }
        view.bringSubviewToFront(dropdownView)
        activeDropdownView = dropdownView
        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight + height)
    }

     /// Send field view to the back of the screen to allow interactions with other field views.
    func sendDropdownViewToBack(dropdownView: UIView) {
        view.sendSubviewToBack(dropdownView)
        updateFieldConstraints(fieldView: dropdownView, height: textFieldHeight)
        view.endEditing(true)
    }
}
