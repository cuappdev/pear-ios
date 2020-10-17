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
        SimpleOnboardingCell(name: "Art", subtitle: "painting, crafts, embroidery..."),
        SimpleOnboardingCell(name: "Business", subtitle: "entrepreneurship, finance, VC..."),
        SimpleOnboardingCell(name: "Cornell AppDev", subtitle: nil),
        SimpleOnboardingCell(name: "Bread Club", subtitle: nil),
        SimpleOnboardingCell(name: "Cornell Venture Capital", subtitle: nil),
        SimpleOnboardingCell(name: "Medium Design Collective", subtitle: nil),
        SimpleOnboardingCell(name: "Women in Computing at Cornell", subtitle: nil),
        SimpleOnboardingCell(name: "Design and Tech Initiative", subtitle: nil)
    ]
    private var selectedInterestsGroups: [SimpleOnboardingCell] = []
    private let userDefaults = UserDefaults.standard

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let nextButton = UIButton()
    private let searchBar = UISearchBar()
    private let skipButton = UIButton()
    private let fadeTableView = FadeWrapperView<UITableView>(UITableView(frame: .zero, style: .plain), fadeColor: .backgroundLightGreen)

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

        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.allowsMultipleSelection = true
        fadeTableView.view.bounces = false
        fadeTableView.view.showsHorizontalScrollIndicator = false
        fadeTableView.view.showsVerticalScrollIndicator = false
        fadeTableView.view.separatorStyle = .none
        fadeTableView.view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
        fadeTableView.view.delegate = self
        fadeTableView.view.dataSource = self
        fadeTableView.view.register(SimpleOnboardingTableViewCell.self, forCellReuseIdentifier: SimpleOnboardingTableViewCell.reuseIdentifier)
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

        skipButton.titleLabel?.font = ._16CircularStdMedium
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.greenGray, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        view.addSubview(skipButton)

        displayedInterestsGroups = interestsGroups

        setupConstraints()
    }

    private func setupConstraints() {
        let backSize = CGSize(width: 86, height: 20)
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

        skipButton.snp.makeConstraints { make in
            make.size.equalTo(backSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.skipBottomPadding)
        }

    }

    /// Filters table view results based on text typed in search
    private func filterTableView(searchText: String) {
        displayedInterestsGroups = searchText.isEmpty
            ? interestsGroups
            : interestsGroups.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        fadeTableView.view.reloadData()
    }

    // MARK: - Next and Previous Buttons
    /// Updates the enabled state of next button based on the state of selectedInterestsGroups.
    private func updateNext() {
        nextButton.isEnabled = selectedInterestsGroups.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
        skipButton.isEnabled = selectedInterestsGroups.count == 0
        let skipButtonColor: UIColor = skipButton.isEnabled ? .greenGray : .inactiveGreen
        skipButton.setTitleColor(skipButtonColor, for: .normal)
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 3)
    }

    @objc func nextButtonPressed() {
        delegate?.nextPage(index: 5)
    }

    @objc func skipButtonPressed() {
        delegate?.nextPage(index: 5)
    }

}

// MARK: - TableViewDelegate
extension InterestsGroupsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = interestsGroups[indexPath.row].subtitle {
            return 61
        } else {
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
