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
    private let skipButton = UIButton()
    private let clubLabel = UILabel()
    private let greetingLabel = UILabel()
    private let nextButton = UIButton()
    private let searchBar = UISearchBar()
    private let tableView = UITableView(frame: .zero, style: .plain)
//    private var tap: UITapGestureRecognizer!

    // MARK: - Gradients
    // Fade out affects on the top and bottom of the tableView
    private let bottomFadeView = UIView()
    private let topFadeView = UIView()

    init(delegate: OnboardingPageDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen

        searchBar.delegate = self
        searchBar.backgroundColor = .backgroundWhite
        searchBar.backgroundImage = UIImage()
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .backgroundWhite
            textField.textColor = UIColor.textBlack
            textField.font = ._20CircularStdBook
        }
        searchBar.layer.cornerRadius = 8
        searchBar.showsCancelButton = false
        view.addSubview(searchBar)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.allowsMultipleSelection = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        view.addSubview(tableView)
        view.addSubview(topFadeView)
        view.addSubview(bottomFadeView)

        clubLabel.text = "What are you a part of?"
        clubLabel.font = ._24CircularStdMedium
        view.addSubview(clubLabel)

        nextButton.setTitle("Ready for Pear", for: .normal)
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

    func setCustomVerticalPadding(size: CGFloat) -> CGFloat {
        let height = UIScreen.main.bounds.height
        let baseHeight: CGFloat = 812
        let heightSize = size * (height / baseHeight)
        return heightSize
    }

    private func setupConstraints() {
        let backSize = CGSize(width: 86, height: 20)
        let fadeHeight: CGFloat = 26
        let nextBackPadding: CGFloat = setCustomVerticalPadding(size: 49)
        let nextBottomPadding: CGFloat = setCustomVerticalPadding(size: 90)
        let nextButtonSize = CGSize(width: 225, height: 54)
        let searchSize = CGSize(width: 295, height: 42)
        let searchTopPadding: CGFloat = 50
        let tableViewWidth: CGFloat = 295
        let tableViewBottomPadding: CGFloat = 57
        let tableViewTopPadding: CGFloat = 24
        let titleHeight: CGFloat = 30
        let titleSpacing: CGFloat = 100
        let topFadeHeight: CGFloat = 10

        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(clubLabel.snp.bottom).offset(searchTopPadding)
            make.size.equalTo(searchSize)
        }

        clubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleSpacing)
        }

        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(tableViewWidth)
            make.top.equalTo(searchBar.snp.bottom).offset(tableViewTopPadding)
            make.bottom.equalTo(nextButton.snp.top).offset(-tableViewBottomPadding)
        }

        topFadeView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(tableView)
            make.height.equalTo(topFadeHeight)
        }

        bottomFadeView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(tableView)
            make.height.equalTo(fadeHeight)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextBottomPadding)
        }

        skipButton.snp.makeConstraints { make in
            make.size.equalTo(backSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextBackPadding)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let clearColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)

        let topLayer = CAGradientLayer()
        topLayer.frame = topFadeView.bounds
        topLayer.colors = [UIColor.backgroundLightGreen.cgColor, clearColor.cgColor]
        topLayer.locations = [0.0, 1.0]
        topFadeView.layer.insertSublayer(topLayer, at: 0)

        let bottomLayer = CAGradientLayer()
        bottomLayer.frame = bottomFadeView.bounds
        bottomLayer.colors = [clearColor.cgColor, UIColor.backgroundLightGreen.cgColor]
        bottomLayer.locations = [0.0, 1.0]
        bottomFadeView.layer.insertSublayer(bottomLayer, at: 0)
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
        tableView.reloadData()
    }

    // MARK: - Next and Previous Buttons
    /// Updates the enabled state of next button based on the state of selectedGroups.
    private func updateNext() {
        nextButton.isEnabled = selectedGroups.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
    }

    @objc func nextButtonPressed() {
        userDefaults.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }

    @objc func skipButtonPressed() {
        userDefaults.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }

}

// MARK: - TableViewDelegate
extension GroupsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroups.append(displayedGroups[indexPath.section])
        updateSearchBarText()
        filterTableView(searchText: getSearchText(from: searchBar.text ?? ""))
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedGroups.removeAll { $0.name == displayedGroups[indexPath.section].name}
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
        let data = displayedGroups[indexPath.section]
        cell.configure(with: data)
        // Keep previous selected cell when reloading tableView
        if selectedGroups.contains(where: { $0.name == data.name }) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return displayedGroups.count
    }

}

extension GroupsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(searchText: getSearchText(from: searchText))
    }

}
