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
    private let pronouns = ["he/his", "she/her", "they/their"]
    private let years = ["2020", "2021", "2022", "2023", "2024"]
    private let majors = ["Computer Science", "Economics", "Psychology", "English", "Government"]
    private let hometowns = ["Boston, MA", "New York, NY", "Washington, DC", "Sacramento, CA", "Ithaca, NY"]
    private let pronounCellReuseIdentifier = "pronounCellReuseIdentifier"
    private let yearCellReuseIdentifier = "yearCellReuseIdentifier"
    private let majorCellReuseIdentifier = "majorCellReuseIdentifier"
    private let hometownCellReuseIdentifier = "hometownCellReuseIdentifier"

    // MARK: - Private View Vars
//    private let classSearchBar = UISearchBar()
    private let greetingLabel = UILabel()
    private let helloLabel = UILabel()
//    private let hometownSearchBar = UISearchBar()
//    private let majorSearchBar = UISearchBar()
    private var classSearchBar: OnboardingSearchView!
    private var majorSearchBar: OnboardingSearchView! //lucy
    private var hometownSearchBar: OnboardingSearchView!
    private let nextButton = UIButton()
    private let pronounsTextField = UITextField()
    private let pronounsTableView = UITableView()

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

        classSearchBar = OnboardingSearchView(tableData: years, reuseIdentifier: yearCellReuseIdentifier, placeholder: "Class of...", delegate: self)
//        classSearchBar.layer.zPosition = 1
        classSearchBar.isUserInteractionEnabled = true
        view.addSubview(classSearchBar)

        majorSearchBar = OnboardingSearchView(tableData: majors, reuseIdentifier: majorCellReuseIdentifier, placeholder: "Major", delegate: self)
//        majorSearchBar.layer.zPosition = 1
        majorSearchBar.isUserInteractionEnabled = true
        view.addSubview(majorSearchBar)

        hometownSearchBar = OnboardingSearchView(tableData: hometowns, reuseIdentifier: hometownCellReuseIdentifier, placeholder: "Hometown", delegate: self)
//        hometownSearchBar.layer.zPosition = 1
        hometownSearchBar.isUserInteractionEnabled = true
        view.addSubview(hometownSearchBar)

        pronounsTextField.backgroundColor = .backgroundLightGray
        pronounsTextField.attributedPlaceholder = NSAttributedString(
            string: "Pronouns",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray]
        )
        pronounsTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 49))
        pronounsTextField.leftViewMode = .always
        pronounsTextField.layer.cornerRadius = fieldsCornerRadius
        view.addSubview(pronounsTextField)

        pronounsTableView.isHidden = true // LUCY - come back to this
        pronounsTableView.layer.zPosition = 1
        pronounsTableView.isScrollEnabled = false
        pronounsTableView.separatorStyle = .none
        pronounsTableView.delegate = self
        pronounsTableView.dataSource = self
        pronounsTableView.backgroundColor = .darkGray
        pronounsTableView.layer.cornerRadius = fieldsCornerRadius
        pronounsTableView.register(UITableViewCell.self, forCellReuseIdentifier: pronounCellReuseIdentifier)
        view.addSubview(pronounsTableView)

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
        let tableViewSidePadding: CGFloat = 32
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

        classSearchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(greetingLabel.snp.bottom).offset(149)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        majorSearchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(classSearchBar.snp.top).offset(textFieldTopPadding+textFieldHeight)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        hometownSearchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(majorSearchBar.snp.top).offset(textFieldTopPadding+textFieldHeight)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        pronounsTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hometownSearchBar.snp.top).offset(textFieldTopPadding+textFieldHeight)
            make.leading.trailing.equalToSuperview().inset(textFieldSidePadding)
            make.height.equalTo(textFieldHeight)
        }

        pronounsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(tableViewSidePadding)
            make.top.equalTo(pronounsTextField.snp.bottom)
            make.height.equalTo(150)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextBottomPadding)
        }
    }
}

// MARK: TableViewDelegate
extension DemographicsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//
//    }

}

// MARK: TableViewDataSource
extension DemographicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pronouns.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: pronounCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = self.pronouns[indexPath.row]
        cell.backgroundColor = .backgroundDarkGray
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        return cell
    }
}

extension DemographicsViewController: OnboardingSearchViewDelegate {
    func bringSearchViewToFront(searchView: OnboardingSearchView) {
        view.bringSubviewToFront(searchView)
        searchView.snp.updateConstraints{ make in
            make.height.equalTo(49+300)
        }
    }

    func sendSearchViewToBack(searchView: OnboardingSearchView) {
        view.sendSubviewToBack(searchView)
        searchView.snp.updateConstraints{ make in
            make.height.equalTo(49)
        }
    }
}



