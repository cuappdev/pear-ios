//
//  SettingsViewController.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import FirebaseAuth
import GoogleSignIn
import UIKit

protocol PausePearDelegate: AnyObject {
    func didUpdatePauseStatus()
    func presentErrorAlert()
}

class SettingsViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let settingsTableView = UITableView()
    private var pauseVisualEffectView = BlurEffectView()
    private var pausePearView: PausePearView!
    private var unpausePearView: UnpausePearView!
    private let user: UserV2
    private var isPaused: Bool?
    private var didUpdatePause = false

    // MARK: - Private Data Vars
    private var settingOptions: [SettingOption] = [
        SettingOption(image: "aboutPear", text: "About Pear"),
        SettingOption(image: "pausePear", text: "Pause Pear"),
        SettingOption(image: "logout", text: "Log Out")
    ]
    
    var profileMenuDelegate: ProfileMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .backgroundLightGreen

        settingsTableView.backgroundColor = .backgroundLightGreen
        settingsTableView.separatorStyle = .none
        settingsTableView.showsVerticalScrollIndicator = false
        settingsTableView.allowsSelection = true
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(SettingOptionTableViewCell.self, forCellReuseIdentifier: SettingOptionTableViewCell.reuseIdentifier)
        view.addSubview(settingsTableView)

        setupNavigationBar()
        setupPausePear()

        setupConstraints()
    }
    
    init(user: UserV2) {
        self.user = user
        self.isPaused = user.isPaused
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(.medium, size: 24)
        ]
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.backButtonSize)
        }
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    private func setupPausePear() {
        pausePearView = PausePearView(delegate: self)
        unpausePearView = UnpausePearView(delegate: self)
    }

    @objc private func backPressed() {
        if didUpdatePause {
            profileMenuDelegate?.didUpdateProfileDemographics()
        }
        navigationController?.popViewController(animated: true)
    }

    private func setupConstraints() {
        settingsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func pushAboutPearViewController() {
        navigationController?.pushViewController(AboutPearViewController(), animated: true)
    }
    
    private func pushEditTimeAvailabilitiesViewController() {
        navigationController?.pushViewController(
            EditTimeAvailabilityViewController(availabilities: user.availability ?? []),
            animated: true
        )
    }

    private func pushEditLocationAvailabilitiesViewController() {
        navigationController?.pushViewController(EditLocationAvailabilityViewController(), animated: true)
    }

    private func pushEditSocialMediaViewController() {
        navigationController?.pushViewController(EditSocialMediaViewController(), animated: true)
    }
    
    private func presentPausePear() {
        guard let superView = self.navigationController?.view, let pausePearView = pausePearView, let unpausePearView = unpausePearView else { return }
        if let isPaused = isPaused, isPaused {
            Animations.presentPopUpView(superView: superView, popUpView: unpausePearView)
        } else {
            Animations.presentPopUpView(superView: superView, popUpView: pausePearView)
        }
    }

}

extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
                settingsTableView.dequeueReusableCell(withIdentifier: SettingOptionTableViewCell.reuseIdentifier,
                        for: indexPath) as? SettingOptionTableViewCell else { return UITableViewCell() }
        let setting = settingOptions[indexPath.row]
        cell.configure(for: setting)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = settingOptions[indexPath.row]
        if option.text == "About Pear" {
            pushAboutPearViewController()
        } else if option.text == "Edit Time Availabilities" {
            pushEditTimeAvailabilitiesViewController()
        } else if option.text == "Edit Location Availabilities" {
            pushEditLocationAvailabilitiesViewController()
        } else if option.text == "Connect Social Media" {
            pushEditSocialMediaViewController()
        } else if option.text == "Pause Pear" {
            presentPausePear()
        } else if option.text == "Log Out" {
            GIDSignIn.sharedInstance()?.signOut()
            do {
                try Auth.auth().signOut()
            } catch {
              print("Error signing out:", error)
            }
            [Constants.UserDefaults.accessToken,
             Constants.UserDefaults.onboardingCompletion,
             Constants.UserDefaults.userNetId,
             Constants.UserDefaults.userProfilePictureURL
            ].forEach(UserDefaults.standard.removeObject(forKey:))
            self.view.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
            self.view.window?.makeKeyAndVisible()
        }
    }

}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        62
    }

}

extension SettingsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
            navigationController?.popViewController(animated: true)
        }
        return false
    }
    
}

extension SettingsViewController: PausePearDelegate {
    
    func didUpdatePauseStatus() {
        didUpdatePause = true
        isPaused?.toggle()
    }
    
    func presentErrorAlert() {
        present(UIAlertController.getStandardErrortAlert(), animated: true)
    }
    
}
