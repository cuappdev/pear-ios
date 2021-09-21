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
    private var displayedGroups: [Group] = []
    private var groups: [Group] = []
    private var selectedGroups: [Group] = []

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let clubLabel = UILabel()
    private let fadeTableView = FadeWrapperView(
        UITableView(),
        fadeColor: .backgroundLightGreen
    )
    private let nextButton = UIButton()
    private let searchBar = UISearchBar()
    private let skipButton = UIButton()
    private let subtitleLabel = UILabel()

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
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.layer.cornerRadius = 8
        searchBar.showsCancelButton = false
        view.addSubview(searchBar)
        
        subtitleLabel.text = "You may select more than 1."
        subtitleLabel.textColor = .greenGray
        subtitleLabel.font = ._12CircularStdBook
        subtitleLabel.textAlignment = .center
        view.addSubview(subtitleLabel)
        
        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.allowsMultipleSelection = true
        fadeTableView.view.isMultipleTouchEnabled = true
        fadeTableView.view.bounces = true
        fadeTableView.view.keyboardDismissMode = .onDrag
        fadeTableView.view.separatorStyle = .none
        fadeTableView.view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
        fadeTableView.view.delegate = self
        fadeTableView.view.dataSource = self
        fadeTableView.view.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
        fadeTableView.view.separatorColor = .clear
        view.addSubview(fadeTableView)

        clubLabel.text = "What are you a part of?"
        clubLabel.font = ._24CircularStdMedium
        view.addSubview(clubLabel)

        nextButton.setTitle("Next", for: .normal)
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        displayedGroups = groups

        getAllGroups()
        getUserGroups()
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
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(clubLabel.snp.bottom).offset(4)
            make.centerX.width.equalTo(clubLabel)
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
    // TOD0: replace local search with search to backend once the route is created
    private func filterTableView(searchText: String) {
        displayedGroups = searchText.isEmpty
            ? groups
            : groups.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        fadeTableView.view.reloadData()
    }

    // MARK: - Next and Previous Buttons
    /// Updates the enabled state of next button based on the state of selectedGroups.
    private func updateNext() {
        nextButton.isEnabled = selectedGroups.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
        skipButton.isEnabled = selectedGroups.count == 0
        skipButton.setTitleColor(
            skipButton.isEnabled ? .greenGray : .inactiveGreen,
            for: .normal
        )
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 1)
    }

    @objc func nextButtonPressed() {
        let selectedGroupsIds = selectedGroups.map { $0.id }
        NetworkManager.updateGroups(groups: selectedGroupsIds) { [weak self] (success) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.delegate?.nextPage(index: 3)
                } else {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
    }

    @objc func skipButtonPressed() {
        delegate?.nextPage(index: 3)
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func getAllGroups() {
        NetworkManager.getAllGroups { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groups):
                DispatchQueue.main.async {
                    self.groups = groups
                    self.displayedGroups = groups
                    self.fadeTableView.view.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func getUserGroups() {
        NetworkManager.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.selectedGroups = user.groups
                    self.fadeTableView.view.reloadData()
                    self.updateNext()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - TableViewDelegate
extension GroupsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedGroups.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroups.append(displayedGroups[indexPath.row])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedGroups.removeAll { $0.id == displayedGroups[indexPath.row].id}
        updateNext()
    }

}

// MARK: - TableViewDataSource
extension GroupsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingTableViewCell.reuseIdentifier,
                                                       for: indexPath) as?
                OnboardingTableViewCell else { return UITableViewCell() }
        let data = displayedGroups[indexPath.row]
        cell.configure(with: data)
        // Keep previous selected cell when reloading tableView
        if selectedGroups.contains(where: { $0.id == data.id }) {
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
