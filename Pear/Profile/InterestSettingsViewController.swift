//
//  AddingInterestSettingsViewController.swift
//  Pear
//
//  Created by Tiffany Pan on 10/18/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class InterestSettingsViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let saveButton = DynamicButton()
    private let fadeTableView = FadeWrapperView(
        UITableView(frame: .zero, style: .plain),
        fadeColor: .backgroundLightGreen
    )
    private let titleLabel = UILabel()

    // MARK: - Data
    private weak var delegate: EditProfileDelegate?
    private var interests: [Interest] = []
    private var selectedInterests: [Interest] = []
    private var updatedUser: UserV2
    
    init(updatingUser: UserV2, delegate: EditProfileDelegate) {
        self.delegate = delegate
        self.selectedInterests = updatingUser.interests
        self.updatedUser = updatingUser
        super.init(nibName: nil, bundle: nil)
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .backgroundLightGreen
        
        /// Set up all subviews and constrain them
        setupTitleLabel()
        setupBackButton()
        setupSaveButton()
        setupFadeTableView()
        
        getAllInterests()
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func saveButtonPressed() {    
        // Update the local user variable with their newly selected variables to perform the two functionalities below this -
        self.updatedUser.interests = selectedInterests
        
        // Network request to update the users new interests on the backend
        let selectedInterestsIds = selectedInterests.map { $0.id }
        NetworkManager.updateInterests(interests: selectedInterestsIds) { [weak self] (success) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !success {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
        
        // Passing the updatedUser and their interest list back to the EditProfileSectionVC
        delegate?.updateInterests(updatedUser: updatedUser, newInterests: selectedInterests)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "What do you love?"
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)
        
        let titleHeight: CGFloat = 30
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }
    }
    
    private func setupFadeTableView() {
        fadeTableView.view.allowsMultipleSelection = true
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
        fadeTableView.view.dataSource = self
        fadeTableView.view.delegate = self
        fadeTableView.view.bounces = true
        fadeTableView.view.keyboardDismissMode = .onDrag
        fadeTableView.view.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
        fadeTableView.view.separatorStyle = .none
        view.addSubview(fadeTableView)
        
        let tableViewTopPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 48)
        let tableViewBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 44)
        
        fadeTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
            make.top.equalTo(titleLabel.snp.bottom).offset(tableViewTopPadding)
            make.bottom.equalTo(saveButton.snp.top).offset(-tableViewBottomPadding)
        }
    }
    
    private func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.layer.cornerRadius = 27
        saveButton.isEnabled = false
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = ._20CircularStdBold
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }
    }
    
    private func getAllInterests() {
        NetworkManager.getAllInterests { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let interests):
                DispatchQueue.main.async {
                    self.interests = interests
                    self.fadeTableView.view.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// Updates the enabled state of save button based on the state of selectedInterests.
    private func updateSave() {
        saveButton.isEnabled = selectedInterests.count > 0
    }

}

// MARK: TableViewDelegate
extension InterestSettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterests.append(interests[indexPath.row])
        updateSave()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedInterests.removeAll { $0.id == interests[indexPath.row].id }
        updateSave()
    }

}

// MARK: TableViewDataSource
extension InterestSettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: OnboardingTableViewCell.reuseIdentifier,
                for: indexPath
        ) as? OnboardingTableViewCell else { return UITableViewCell() }
        let data = interests[indexPath.row]
        cell.configure(with: data)
        if selectedInterests.contains(where: { $0.id == data.id }) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }

}
