//
//  SettingsViewController.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/7/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

protocol PausePearDelegate: class {
    func presentPausePear()
    func pausePearAction(data: String)
    func removePausePear()
}

class SettingsViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let settingsTableView = UITableView()
    private var pauseBlurEffect: UIBlurEffect!
    private var pauseVisualEffectView: UIVisualEffectView!
    private var pausePearView: PausePearView!
    
    // MARK: - Private Data Vars
    private var settingOptions: [SettingOption] = [
        SettingOption(image: "pausePear", text: "Pause Pear", hasSwitch: true, switchOn: false),
        SettingOption(image: "editAvailability", text: "Edit Availabilities", hasSwitch: false, switchOn: false),
        SettingOption(image: "socialMedia", text: "Connect Social Media", hasSwitch: false, switchOn: false),
        SettingOption(image: "aboutPear", text: "About Pear", hasSwitch: false, switchOn: false),
        SettingOption(image: "logout", text: "Log Out", hasSwitch: false, switchOn: false)
    ]

    let settingsReuseIdentifier = "settingsReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        view.backgroundColor = .backgroundLightGreen
        
        settingsTableView.backgroundColor = .backgroundLightGreen
        settingsTableView.separatorStyle = .none
        settingsTableView.showsVerticalScrollIndicator = false
        settingsTableView.allowsSelection = true
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(SettingOptionTableViewCell.self, forCellReuseIdentifier: settingsReuseIdentifier)
        view.addSubview(settingsTableView)
        
        setupNavigationBar()
        setupPausePear()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(.medium, size: 24)
        ]

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 10, height: 20))
        }
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupPausePear() {
        pausePearView = PausePearView(delegate: self)
        pauseBlurEffect = UIBlurEffect(style: .regular)
        pauseVisualEffectView = UIVisualEffectView(effect: pauseBlurEffect)
    }
    
    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        settingsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func pushAboutPearViewController() {
        navigationController?.pushViewController(AboutPearViewController(), animated: true)
    }
    
    private func pushEditAvailabilitiesViewController() {
        navigationController?.pushViewController(EditAvailabilityViewController(), animated: true)
    }
    
    private func pushConnectSocialMediaViewController() {
        navigationController?.pushViewController(ConnectSocialMediaViewController(), animated: true)
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingsTableView.dequeueReusableCell(withIdentifier: settingsReuseIdentifier, for: indexPath) as? SettingOptionTableViewCell else { return UITableViewCell() }
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
        }
        else if option.text == "Connect Social Media" {
            pushConnectSocialMediaViewController()
        }
        else if option.text == "Edit Availabilities" {
            pushEditAvailabilitiesViewController()
        }
    }
    
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        62
    }
}

extension SettingsViewController: PausePearDelegate {
    
    func presentPausePear() {
        pauseVisualEffectView.frame = self.view.frame
        view.addSubview(pauseVisualEffectView)
        view.addSubview(pausePearView)
        
        pausePearView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(305)
            make.width.equalTo(295)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.pausePearView.transform = .init(scaleX: 1.5, y: 1.5)
            self.pauseVisualEffectView.alpha = 1
            self.pausePearView.alpha = 1
            self.pausePearView.transform = .identity
        })
        
    }
    
    func pausePearAction(data: String) {
        print("paused for \(data)")
    }
    func removePausePear() {
        UIView.animate(withDuration: 0.15) {
            self.pauseVisualEffectView.alpha = 0
            self.pausePearView.alpha = 0
            self.pausePearView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { (_) in
            self.pausePearView.removeFromSuperview()
        }
    }
}
