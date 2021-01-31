//
//  ProfileMenuViewController.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 4/4/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

class ProfileMenuViewController: UIViewController {

    private let editButton = UIButton()
    private let optionsTableView = UITableView()
    private let profileImageView = UIImageView()
    private let profileInfoLabel = UILabel()
    private let profileNameLabel = UILabel()

    private let menuOptionCellReuseId = "MenuOptionCellReuseIdentifier"
    private let editButtonSize = CGSize(width: 70, height: 30)
    private let menuOptions: [MenuOption] = [
        MenuOption(image: "interests", text: "Your interests"),
        MenuOption(image: "groups", text: "Your groups"),
        MenuOption(image: "settings", text: "Settings")
    ]
    private let profileImageSize = CGSize(width: 120, height: 120)
    private var user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true

        let firstName = user.firstName
        let lastName = user.lastName
        let major = user.major

        let year: String
        if let graduationYear = user.graduationYear {
            year = graduationYear
        } else {
            year = String(Time.thisYear)
        }
        let hometown = user.hometown

        editButton.backgroundColor = .backgroundWhite
        editButton.setTitle("Edit Info", for: .normal)
        editButton.setTitleColor(.backgroundOrange, for: .normal)
        editButton.titleLabel?.font = ._12CircularStdMedium
        editButton.layer.cornerRadius = editButtonSize.height/2
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        editButton.layer.shadowOpacity = 0.15
        editButton.layer.shadowRadius = 2
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        view.addSubview(editButton)
        view.bringSubviewToFront(editButton)

        optionsTableView.backgroundColor = .backgroundLightGreen
        optionsTableView.separatorStyle = .none
        optionsTableView.showsVerticalScrollIndicator = false
        optionsTableView.isScrollEnabled = false
        optionsTableView.allowsSelection = true
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        optionsTableView.register(MenuOptionTableViewCell.self, forCellReuseIdentifier: menuOptionCellReuseId)
        view.addSubview(optionsTableView)

        profileImageView.backgroundColor = .inactiveGreen
        profileImageView.layer.cornerRadius = profileImageSize.width/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        if let profilePictureURL = URL(string: user.profilePictureURL) {
            profileImageView.kf.setImage(with: profilePictureURL)
        }
        view.addSubview(profileImageView)
        view.sendSubviewToBack(profileImageView)

        profileInfoLabel.text = "\(major) \(year)\nFrom \(hometown)"
        profileInfoLabel.textColor = .greenGray
        profileInfoLabel.font = ._16CircularStdBook
        profileInfoLabel.numberOfLines = 0
        view.addSubview(profileInfoLabel)

        profileNameLabel.text = "\(firstName) \(lastName)"
        profileNameLabel.textColor = .black
        profileNameLabel.numberOfLines = 0
        profileNameLabel.font = ._24CircularStdMedium
        view.addSubview(profileNameLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        let leftPadding = 25

        editButton.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.size.equalTo(editButtonSize)
        }

        optionsTableView.snp.makeConstraints { make in
            make.top.equalTo(profileInfoLabel.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.size.equalTo(profileImageSize)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }

        profileInfoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(profileNameLabel.snp.bottom).offset(5)
        }

        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
        }
    }

    @objc private func editPressed() {
        let editDemographicsVC = EditDemographicsViewController(user: user)
        navigationController?.pushViewController(editDemographicsVC, animated: false)
    }

    func pushEditingInterestsViewController() {
        navigationController?.pushViewController(EditingViewController(user: user, isShowingGroups: false), animated: false)
    }

    func pushEditingGroupsViewController() {
        navigationController?.pushViewController(EditingViewController(user: user, isShowingGroups: true), animated: false)
    }

    func pushSettingsViewController() {
        navigationController?.pushViewController(SettingsViewController(), animated: false)
    }

}

extension ProfileMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: menuOptionCellReuseId,
                                                       for: indexPath) as?
            MenuOptionTableViewCell else { return UITableViewCell() }
        let option = menuOptions[indexPath.row]
        cell.configure(for: option)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = menuOptions[indexPath.row]
        if option.text == "Your interests" {
            pushEditingInterestsViewController()
        } else if option.text == "Your groups" {
            pushEditingGroupsViewController()
        } else if option.text == "Settings" {
            pushSettingsViewController()
        }
    }

}

extension ProfileMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

}
