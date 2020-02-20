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

    private var fieldsEntered: [Bool] = [false, false, false, false] // Keep track of selection status of each field.

    // MARK: - Private View Vars
    private var classDropdownView: OnboardingSelectDropdownView!
    private let greetingLabel = UILabel()
    private let helloLabel = UILabel()
    private var hometownSearchView: OnboardingSearchDropdownView!
    private var majorSearchView: OnboardingSearchDropdownView!
    private let nextButton = UIButton()
    private var onboardingSearchViews: [OnboardingSearchDropdownView] = []
    private var onboardingSelectViews: [OnboardingSelectDropdownView] = []
    private var pronounsDropdownView: OnboardingSelectDropdownView!
    private let pronounsTableView = UITableView()

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
        navigationController?.navigationBar.isHidden = true

        helloLabel.text = "Hi \(userDefaults.string(forKey: "userFirstName") ?? "user")!"
        helloLabel.textColor = .textBlack
        helloLabel.font = ._24CircularStdMedium
        view.addSubview(helloLabel)

        greetingLabel.text = "Let's get to know you better."
        greetingLabel.textColor = .textBlack
        greetingLabel.font = ._24CircularStdMedium
        view.addSubview(greetingLabel)

        // Renders the valid graduation years based on current year.
        let currentYear = Calendar.current.component(.year, from: Date())
        for year in currentYear...currentYear+4 {
            classSearchFields.append("\(year)")
        }

        classDropdownView = OnboardingSelectDropdownView(delegate: self, placeholder: "Class of...", tableData: classSearchFields, textTemplate: "Class of")
        classDropdownView.tag = 0 // Set tag to keep track of field selection status.
        view.addSubview(classDropdownView)

        majorSearchView = OnboardingSearchDropdownView(delegate: self, placeholder: "Major", tableData: majorSearchFields)
        majorSearchView.tag = 1 // Set tag to keep track of field selection status.
        view.addSubview(majorSearchView)

        hometownSearchView = OnboardingSearchDropdownView(delegate: self, placeholder: "Hometown", tableData: hometownSearchFields)
        hometownSearchView.tag = 2 // Set tag to keep track of field selection status.
        view.addSubview(hometownSearchView)

        pronounsDropdownView = OnboardingSelectDropdownView(delegate: self, placeholder: "Pronouns", tableData: pronounSearchFields, textTemplate: "")
        pronounsDropdownView.tag = 3 // Set tag to keep track of field selection status.
        view.addSubview(pronounsDropdownView)

        onboardingSearchViews = [majorSearchView, hometownSearchView]
        onboardingSelectViews = [classDropdownView, pronounsDropdownView]

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.isEnabled = false
        nextButton.layer.cornerRadius = 26
        nextButton.layer.shadowColor = .none
        nextButton.layer.shadowOffset = CGSize(width: 0.0 , height: 0.0)
        nextButton.layer.shadowOpacity = 0
        nextButton.layer.shadowRadius = 0
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        setUpConstraints()
    }

    @objc private func nextButtonPressed() {
        delegate?.nextPage(index: 1)
    }

    private func setUpConstraints() {
        let fieldTopPadding: CGFloat = LayoutHelper.shared.setCustomVerticalPadding(size: 60)
        let helloLabelHeight: CGFloat = 30
        let helloLabelPadding: CGFloat = LayoutHelper.shared.setCustomVerticalPadding(size: 100)
        let nextBottomPadding: CGFloat = LayoutHelper.shared.setCustomVerticalPadding(size: 90)
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

    private func updateFieldConstraints(fieldView: UIView, height: CGFloat) {
        fieldView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

extension DemographicsViewController: OnboardingSearchViewDelegate {

    private func numberFieldsSelected() -> Int {
        var count = 0
        for field in fieldsEntered where field { count+=1 }
        return count
    }

    internal func updateSelectedFields(tag: Int, isSelected: Bool) {
        fieldsEntered[tag] = isSelected
        nextButton.isEnabled = numberFieldsSelected() == 4
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
        nextButton.layer.shadowColor = nextButton.isEnabled ? UIColor.black.cgColor : .none
        nextButton.layer.shadowOffset = nextButton.isEnabled ? CGSize(width: 0.0, height: 2.0) : CGSize(width: 0.0, height: 0.0)
        nextButton.layer.shadowOpacity = nextButton.isEnabled ? 0.15 : 0
        nextButton.layer.shadowRadius = nextButton.isEnabled ? 2 : 0
    }

    /// Resizes search view based on input to search field
    internal func updateSearchViewHeight(searchView: UIView, height: CGFloat) {
        view.bringSubviewToFront(searchView)
        updateFieldConstraints(fieldView: searchView, height: textFieldHeight + height)
    }

    internal func bringSearchViewToFront(searchView: UIView, height: CGFloat, isSelect: Bool) {
        view.bringSubviewToFront(searchView)

        if isSelect { view.endEditing(true) } // Dismiss keyboard when user clicks on select field.

        updateFieldConstraints(fieldView: searchView, height: textFieldHeight + height)

        // TODO: Some jank code here
        onboardingSearchViews.forEach {
            if !$0.isEqual(searchView) {
                view.sendSubviewToBack($0)
                $0.collapseTableView()
                $0.snp.updateConstraints { make in
                    make.height.equalTo(textFieldHeight)
                }
            }
        }

        onboardingSelectViews.forEach {
            if !$0.isEqual(searchView) {
                view.sendSubviewToBack($0)
                $0.collapseTableView()
                $0.snp.updateConstraints{ make in
                    make.height.equalTo(textFieldHeight)
                }
            }
        }
    }

    internal func sendSearchViewToBack(searchView: UIView) {
        view.sendSubviewToBack(searchView)
        updateFieldConstraints(fieldView: searchView, height: textFieldHeight)
        view.endEditing(true)
    }
}
