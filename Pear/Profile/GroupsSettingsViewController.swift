//
//  AddingGroupSettingsViewController.swift
//  Pear
//
//  Created by Tiffany Pan on 10/18/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class GroupsSettingsViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: EditProfileDelegate?
    private var displayedGroups: [Group] = []
    private var groups: [Group] = []
    private var selectedGroups: [Group] = []
    private var updatedUser: UserV2
    
    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let clubLabel = UILabel()
    private let fadeTableView = FadeWrapperView(
        UITableView(),
        fadeColor: .backgroundLightGreen
    )
    private let saveButton = DynamicButton()
    private let searchBar = UISearchBar()
    private let subtitleLabel = UILabel()

    init(updatingUser: UserV2, delegate: EditProfileDelegate) {
        selectedGroups = updatingUser.groups
        self.delegate = delegate
        updatedUser = updatingUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.isNavigationBarHidden = true
        
        /// Set up all subviews and constrain them
        setupClubLabel()
        setupBackButton()
        setupSearchBar()
        setupSubtitleLabel()
        setupSaveButton()
        setupFadeTableView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        displayedGroups = groups
        getAllGroups()
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(clubLabel)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }
    }
    
    private func setupSearchBar() {
        let searchBarTopPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 48)
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
        
        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(clubLabel.snp.bottom).offset(searchBarTopPadding)
            make.size.equalTo(CGSize(width: 295, height: 40))
        }
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.text = "You may select more than 1."
        subtitleLabel.textColor = .greenGray
        subtitleLabel.font = ._12CircularStdBook
        subtitleLabel.textAlignment = .center
        view.addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(clubLabel.snp.bottom).offset(4)
            make.centerX.width.equalTo(clubLabel)
        }
    }
    
    private func setupFadeTableView() {
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
        
        fadeTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
            make.top.equalTo(searchBar.snp.bottom).offset(17)
            make.bottom.equalTo(saveButton.snp.top).offset(-57)
        }
    }
    
    private func setupClubLabel() {
        clubLabel.text = "What are you a part of?"
        clubLabel.font = ._24CircularStdMedium
        view.addSubview(clubLabel)
        
        clubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }
    }
    
    private func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = ._20CircularStdBold
        saveButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
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
    /// Updates the enabled state of the save button based on the state of selectedGroups.
    private func updateSave() {
        saveButton.isEnabled = selectedGroups.count > 0
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func saveButtonPressed() {
        self.updatedUser.groups = selectedGroups
        
        let selectedGroupsIds = selectedGroups.map { $0.id }
        NetworkManager.updateGroups(groups: selectedGroupsIds) { [weak self] (success) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !success {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
        
        delegate?.updateGroups(updatedUser: updatedUser, newGroups: selectedGroups)
        navigationController?.popViewController(animated: true)
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
}

// MARK: - TableViewDelegate
extension GroupsSettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedGroups.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroups.append(displayedGroups[indexPath.row])
        updateSave()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedGroups.removeAll { $0.id == displayedGroups[indexPath.row].id}
        updateSave()
    }

}

// MARK: - TableViewDataSource
extension GroupsSettingsViewController: UITableViewDataSource {

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
extension GroupsSettingsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
