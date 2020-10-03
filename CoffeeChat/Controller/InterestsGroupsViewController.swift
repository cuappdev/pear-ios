//
//  InterestsGroupsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class InterestsGroupsViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?
    // TODO: change when networking with backend
    private var displayedInterestsGroups: [SimpleOnboardingCell] = []
    private var interestsGroups: [SimpleOnboardingCell] = [
        SimpleOnboardingCell(name: "Art", type: .interest, categories: "painting, crafts, embroidery..."),
        SimpleOnboardingCell(name: "Business", type: .interest, categories: "entrepreneurship, finance, VC..."),
        SimpleOnboardingCell(name: "Cornell AppDev", type: .normal, categories: nil),
        SimpleOnboardingCell(name: "Bread Club", type: .normal, categories: nil),
        SimpleOnboardingCell(name: "Cornell Venture Capital", type: .normal, categories: nil),
        SimpleOnboardingCell(name: "Medium Design Collective", type: .normal, categories: nil),
        SimpleOnboardingCell(name: "Women in Computing at Cornell", type: .normal, categories: nil),
        SimpleOnboardingCell(name: "Design and Tech Initiative", type: .normal, categories: nil)
    ]
    private var selectedInterestsGroups: [SimpleOnboardingCell] = []
    private let userDefaults = UserDefaults.standard

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let nextButton = UIButton()
    private let searchBar = UISearchBar()
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
        searchBar.placeholder = "Search interests and groups"
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

        titleLabel.text = "What do you most want\nto talk about?"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        nextButton.setTitle("Almost there", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = 26
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        displayedInterestsGroups = interestsGroups

        setupConstraints()
    }

    private func setupConstraints() {
        let searchBarTopPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 40)

        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(6)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }

        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(searchBarTopPadding)
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

    }

    /// Filters table view results based on text typed in search
    private func filterTableView(searchText: String) {
        displayedInterestsGroups = searchText.isEmpty
            ? interestsGroups
            : interestsGroups.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        fadeTableView.tableView.reloadData()
    }

    // MARK: - Next and Previous Buttons
    /// Updates the enabled state of next button based on the state of selectedInterestsGroups.
    private func updateNext() {
        nextButton.isEnabled = selectedInterestsGroups.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 3)
    }

    @objc func nextButtonPressed() {
        userDefaults.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }

}

// MARK: - TableViewDelegate
extension InterestsGroupsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch interestsGroups[indexPath.row].type {
        case .interest:
            return 61
        case .normal:
            return 54
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedInterestsGroups.count
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterestsGroups.append(displayedInterestsGroups[indexPath.row])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedInterestsGroups.removeAll { $0.name == displayedInterestsGroups[indexPath.row].name}
        updateNext()
    }

}

// MARK: - TableViewDataSource
extension InterestsGroupsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        SimpleOnboardingTableViewCell.reuseIdentifier, for: indexPath) as?
                SimpleOnboardingTableViewCell else { return UITableViewCell() }
        let data = displayedInterestsGroups[indexPath.row]
        cell.configure(with: data)
        // Keep previous selected cell when reloading tableView
        if selectedInterestsGroups.contains(where: { $0.name == data.name }) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }

}

// MARK: - SearchBarDelegate
extension InterestsGroupsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(searchText: searchText)
    }

}
