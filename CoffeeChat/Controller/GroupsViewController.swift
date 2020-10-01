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
    // TODO: change when networking with backend
    private var displayedGroups: [String] = []
    private var groups: [String] = [
        "AppDev",
        "DTI",
        "Guac Magazine",
        "GCC",
        "GVC",
        "CUABS",
        "Bread Club",
        "CUSD"
    ]
    private var selectedGroups: [String] = []
    private let userDefaults = UserDefaults.standard

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let clubLabel = UILabel()
    private let greetingLabel = UILabel()
    private let nextButton = UIButton()
    private let searchBar = UISearchBar()
    private let skipButton = UIButton()
    private let fadeTableView = FadeTableView(fadeColor: UIColor.backgroundLightGreen)

    init(delegate: OnboardingPageDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        searchBar.delegate = self
        searchBar.backgroundColor = .backgroundWhite
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = .backgroundWhite
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = ._16CircularStdBook
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.layer.cornerRadius = 8
        searchBar.showsCancelButton = false
        view.addSubview(searchBar)

        fadeTableView.tableView.delegate = self
        fadeTableView.tableView.dataSource = self
        fadeTableView.tableView.register(SimpleOnboardingTableViewCell.self, forCellReuseIdentifier: SimpleOnboardingTableViewCell.reuseIdentifier)
        view.addSubview(fadeTableView)


        clubLabel.text = "What are you a part of?"
        clubLabel.font = ._24CircularStdMedium
        view.addSubview(clubLabel)

        nextButton.setTitle("Almost there", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = 26
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        skipButton.titleLabel?.font = ._16CircularStdMedium
        skipButton.setTitle("I'll add later", for: .normal)
        skipButton.setTitleColor(.greenGray, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        view.addSubview(skipButton)

        displayedGroups = groups

        setupConstraints()
    }

    private func setupConstraints() {
        let searchBarTopPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 48)

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(clubLabel)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        clubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }

        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(clubLabel.snp.bottom).offset(searchBarTopPadding)
            make.size.equalTo(CGSize(width: 295, height: 40))
        }

        fadeTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
            make.top.equalTo(searchBar.snp.bottom).offset(17)
            make.bottom.equalTo(nextButton.snp.top).offset(-57)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }

        skipButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 86, height: 20))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.skipBottomPadding)
        }
    }

    // MARK: - Search Bar

    /// Filters table view results based on text typed in search
    private func filterTableView(searchText: String) {
        displayedGroups = searchText.isEmpty
            ? groups
            : groups.filter { $0.localizedCaseInsensitiveContains(searchText) }
        fadeTableView.tableView.reloadData()
    }

    // MARK: - Next and Previous Buttons
    /// Updates the enabled state of next button based on the state of selectedGroups.
    private func updateNext() {
        nextButton.isEnabled = selectedGroups.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 1)
    }

    @objc func nextButtonPressed() {
        let userGroups = selectedGroups.map { $0 }
        userDefaults.set(userGroups, forKey: Constants.UserDefaults.userClubs)
        updateUser()
        delegate?.nextPage(index: 3)
    }

    @objc func skipButtonPressed() {
        delegate?.nextPage(index: 3)
    }


    private func updateUser() {
        if let clubs = userDefaults.array(forKey: Constants.UserDefaults.userClubs) as? [String],
           let graduationYear = userDefaults.string(forKey: Constants.UserDefaults.userGraduationYear),
           let hometown = userDefaults.string(forKey: Constants.UserDefaults.userHometown),
           let interests = userDefaults.array(forKey: Constants.UserDefaults.userInterests) as? [String],
           let major = userDefaults.string(forKey: Constants.UserDefaults.userMajor),
           let pronouns = userDefaults.string(forKey: Constants.UserDefaults.userPronouns) {
            NetworkManager.shared.updateUser(clubs: clubs,
                                             graduationYear: graduationYear,
                                             hometown: hometown,
                                             interests: interests,
                                             major: major,
                                             pronouns: pronouns).observe { result in
                switch result {
                case .value(let response):
                    print(response)
                case .error(let error):
                    print(error)
                }
            }
        }
    }

}

// MARK: - TableViewDelegate
extension GroupsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedGroups.count
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroups.append(displayedGroups[indexPath.row])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedGroups.removeAll { $0 == displayedGroups[indexPath.row]}
        updateNext()
    }

}

// MARK: - TableViewDataSource
extension GroupsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleOnboardingTableViewCell.reuseIdentifier, for: indexPath) as?
                SimpleOnboardingTableViewCell else { return UITableViewCell() }
        let data = displayedGroups[indexPath.row]
        cell.configure(with: data, type: .normal, subtitle: nil)
        // Keep previous selected cell when reloading tableView
        if selectedGroups.contains(where: { $0 == data }) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }

}

// MARK: - SearchBarDelegate
extension GroupsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(searchText: searchText)
    }

}
