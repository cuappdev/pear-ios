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
    private var selectedGroups: [Group] = []

    // TODO: change when networking with backend
    private var groups: [Group] = [
        Group(name: "Apple", image: ""),
        Group(name: "banana", image: ""),
        Group(name: "Cornell AppDev", image: ""),
        Group(name: "dandelion", image: ""),
        Group(name: "giraffe", image: ""),
        Group(name: "heap", image: ""),
        Group(name: "Igloo", image: ""),
        Group(name: "Jeans", image: "")
    ]
    private var displayedGroups: [Group] = []
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
        searchBar.searchTextField.backgroundColor = .backgroundWhite
        searchBar.searchTextField.textColor = .textBlack
        searchBar.searchTextField.font = ._20CircularStdBook
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.layer.cornerRadius = 8
        searchBar.showsCancelButton = false
        view.addSubview(searchBar)

        fadeTableView.tableView.delegate = self
        fadeTableView.tableView.dataSource = self
        fadeTableView.tableView.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
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
        let backButtonSize = CGSize(width: 10, height: 18)
        let backSize = CGSize(width: 86, height: 20)
        let skipBottomPadding: CGFloat = Constants.Onboarding.skipBottomPadding
        let nextBottomPadding: CGFloat = Constants.Onboarding.nextBottomPadding
        let nextButtonSize = CGSize(width: 225, height: 54)
        let searchSize = CGSize(width: 295, height: 42)
        let searchTopPadding: CGFloat = 48
        let tableViewWidth: CGFloat = 295
        let tableViewBottomPadding: CGFloat = 57
        let tableViewTopPadding: CGFloat = 24
        let titleHeight: CGFloat = 30
        let titleLabelPadding: CGFloat = Constants.Onboarding.titleLabelPadding

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(clubLabel)
            make.size.equalTo(backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(clubLabel.snp.bottom).offset(searchTopPadding)
            make.size.equalTo(searchSize)
        }

        clubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleLabelPadding)
        }

        fadeTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(tableViewWidth)
            make.top.equalTo(searchBar.snp.bottom).offset(tableViewTopPadding)
            make.bottom.equalTo(nextButton.snp.top).offset(-tableViewBottomPadding)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextBottomPadding)
        }

        skipButton.snp.makeConstraints { make in
            make.size.equalTo(backSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(skipBottomPadding)
        }
    }

    // MARK: - Search Bar
    /// Updates the search bar text based on currently selected Groups.
    private func updateSearchBarText() {
        if selectedGroups.isEmpty {
            searchBar.text = ""
            return
        }

        // Number of characters before list is considered "too long" and shortened to "..."
        let maxChar = 20
        let wordLong = 15

        let listString = (selectedGroups.map { $0.name }).joined(separator: ", ")
        let lastComma = listString.lastIndex(of: ",")

        if let comma = lastComma {
            let lastWordLength = listString.count - comma.utf16Offset(in: listString) - 2
            if listString.count < maxChar {
                searchBar.text = "\(listString), "
            } else if listString.count > maxChar && lastWordLength < wordLong { // Last word is short enough to show
                searchBar.text = "...\(listString.suffix(from: comma)), "
            } else { // Both the entire string and the last word are too long to display
                searchBar.text = "..., "
            }
        } else if listString.count < maxChar { // listString is one item, and show it if its short
            searchBar.text = "\(listString), "
        }
    }

    /// Retrieves user typed search text from searchBar
    private func getSearchText(from searchText: String) -> String {
        guard let lastGroupName = selectedGroups.last?.name else { return searchBar.text ?? "" }
        let result: String
        if searchText.contains(lastGroupName) { // Search for text after listing
            result = searchText.components(separatedBy: lastGroupName + ", ").last ?? ""
        } else if searchText.contains("..., ") { // Search for text after ..., "
            result = searchText.components(separatedBy: "..., ").last ?? ""
        } else if searchText.contains(", ") { // User backspaced into the previous list item
            result = searchText.components(separatedBy: ", ").last ?? ""
        } else { // User is deleting list, and should show all options
          result = ""
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Filters table view results based on text typed in search
    private func filterTableView(searchText: String) {
        displayedGroups = searchText.isEmpty
            ? groups
            : groups.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
        let userGroups = selectedGroups.map { $0.name }
        userDefaults.set(userGroups, forKey: Constants.UserDefaults.userClubs)
        userDefaults.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        updateUser()
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

    @objc func skipButtonPressed() {
        delegate?.nextPage(index: 3)
    }

}

// MARK: - TableViewDelegate
extension GroupsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedGroups.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroups.append(displayedGroups[indexPath.row])
        updateSearchBarText()
        filterTableView(searchText: getSearchText(from: searchBar.text ?? ""))
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedGroups.removeAll { $0.name == displayedGroups[indexPath.row].name}
        updateSearchBarText()
        filterTableView(searchText: getSearchText(from: searchBar.text ?? ""))
        updateNext()
    }

}

// MARK: - TableViewDataSource
extension GroupsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            OnboardingTableViewCell.reuseIdentifier, for: indexPath) as?
        OnboardingTableViewCell else { return UITableViewCell() }
        let data = displayedGroups[indexPath.row]
        cell.configure(with: data)
        // Keep previous selected cell when reloading tableView
        if selectedGroups.contains(where: { $0.name == data.name }) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }

}

// MARK: - SearchBarDelegate
extension GroupsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(searchText: getSearchText(from: searchText))
    }

}
