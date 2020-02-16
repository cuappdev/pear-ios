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
    private let classSearchFields = ["2020", "2021", "2022", "2023", "2024"]
    private let hometownSearchFields = ["Boston, MA", "New York, NY", "Washington, DC", "Sacramento, CA", "Ithaca, NY"]
    private let majorSearchFields = ["Computer Science", "Economics", "Psychology", "English", "Government"]
    private let pronounSearchFields = ["She/Her/Hers", "He/Him/His", "They/Them/Theirs"]

    // MARK: - Private View Vars
    private let greetingLabel = UILabel()
    private let helloLabel = UILabel()
    private var classDropdownView: OnboardingDropdownView!
    private var majorSearchView: OnboardingSearchView!
    private var hometownSearchView: OnboardingSearchView!
    private let nextButton = UIButton()
    private var pronounsDropdownView: OnboardingDropdownView!
    private let pronounsTableView = UITableView()

//    private var fieldViews: [UIView] = []

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

        classDropdownView = OnboardingDropdownView(delegate: self, placeholder: "Class of...", tableData: classSearchFields)
        classDropdownView.isUserInteractionEnabled = true
        view.addSubview(classDropdownView)

        majorSearchView = OnboardingSearchView(delegate: self, placeholder: "Major", tableData: majorSearchFields)
        majorSearchView.isUserInteractionEnabled = true
        view.addSubview(majorSearchView)

        hometownSearchView = OnboardingSearchView(delegate: self, placeholder: "Hometown", tableData: hometownSearchFields)
        hometownSearchView.isUserInteractionEnabled = true
        view.addSubview(hometownSearchView)

        pronounsDropdownView = OnboardingDropdownView(delegate: self, placeholder: "Pronouns", tableData: pronounSearchFields)
        pronounsDropdownView.isUserInteractionEnabled = true
        view.addSubview(pronounsDropdownView)

//        fieldViews = [classDropdownView, majorSearchView, hometownSearchView, pronounsDropdownView]

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.textBlack, for: .normal)
        nextButton.backgroundColor = .backgroundLightGray
        nextButton.layer.cornerRadius = 26
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTableViews))
//        view.addGestureRecognizer(tapGestureRecognizer)

        setUpConstraints()
    }

    @objc func nextButtonPressed() {
        delegate?.nextPage(index: 1)
    }

//    @objc func dismissTableViews(_ sender: UITapGestureRecognizer? = nil) {
//        print("tapped in big view")
//        fieldViews.forEach {
//            print($0)
//            view.sendSubviewToBack($0)
//            $0.snp.updateConstraints{ make in
//                make.height.equalTo(49)
//            }
//        }
//    }

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

        classDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(greetingLabel.snp.bottom).offset(149)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        majorSearchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(classDropdownView.snp.top).offset(textFieldTopPadding+textFieldHeight)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        hometownSearchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(majorSearchView.snp.top).offset(textFieldTopPadding+textFieldHeight)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        pronounsDropdownView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hometownSearchView.snp.top).offset(textFieldTopPadding+textFieldHeight)
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
    func bringSearchViewToFront(searchView: UIView) {
        view.bringSubviewToFront(searchView)
        searchView.snp.updateConstraints{ make in
            make.height.equalTo(49+300)
        }
    }

    func sendSearchViewToBack(searchView: UIView) {
        view.sendSubviewToBack(searchView)
        searchView.snp.updateConstraints{ make in
            make.height.equalTo(49)
        }
    }
}



