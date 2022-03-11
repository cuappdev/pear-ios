//
//  ProfileMenuViewController.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 4/4/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit

protocol ProfileMenuDelegate: AnyObject {
    func didUpdateProfilePicture(image: UIImage?, url: String)
    func didUpdateProfileDemographics()
}

class ProfileMenuViewController: UIViewController {

    // MARK: - Private View Vars
    private let optionsTableView = UITableView()
    private let profileImageView = UIImageView()
    private let profileInfoLabel = UILabel()
    private let profileNameLabel = UILabel()

    // MARK: - Private Data Vars
    private let menuOptions: [MenuOption] = [
        MenuOption(image: "profile", text: "Your Profile"),
        MenuOption(image: "messageIcon", text: "Messages"),
        MenuOption(image: "settings", text: "Settings")
    ]
    private let profileImageSize = CGSize(width: 120, height: 120)
    private var user: UserV2
    
    var delegate: ProfileMenuDelegate?

    init(user: UserV2) {
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

        guard let year = user.graduationYear,
              let hometown = user.hometown,
              user.majors.count > 0 else {
            return
        }

        let firstName = user.firstName
        let lastName = user.lastName

        optionsTableView.backgroundColor = .backgroundLightGreen
        optionsTableView.separatorStyle = .none
        optionsTableView.showsVerticalScrollIndicator = false
        optionsTableView.isScrollEnabled = false
        optionsTableView.allowsSelection = true
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        optionsTableView.register(MenuOptionTableViewCell.self, forCellReuseIdentifier: MenuOptionTableViewCell.reuseIdentifier)
        view.addSubview(optionsTableView)

        profileImageView.backgroundColor = .inactiveGreen
        profileImageView.layer.cornerRadius = profileImageSize.width/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.isUserInteractionEnabled = true
        if let profilePictureURL = URL(string: user.profilePicUrl) {
            profileImageView.kf.setImage(with: profilePictureURL)
        }
   
        view.addSubview(profileImageView)
        view.sendSubviewToBack(profileImageView)

        profileInfoLabel.text = "\(user.majors[0].name) \(year)\nFrom \(hometown)"
        profileInfoLabel.textColor = .greenGray
        profileInfoLabel.font = ._16CircularStdBook
        profileInfoLabel.numberOfLines = 0
        view.addSubview(profileInfoLabel)

        profileNameLabel.text = "\(firstName) \(lastName)"
        profileNameLabel.lineBreakMode = .byWordWrapping
        profileNameLabel.textColor = .black
        profileNameLabel.numberOfLines = 0
        profileNameLabel.font = ._24CircularStdMedium
        view.addSubview(profileNameLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        let leftPadding = 25

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
            make.leading.trailing.equalToSuperview().inset(leftPadding)
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
        }
    }

    private func pushEditingProfileViewController() {
        let editProfileVC = ProfileViewController(user: user, viewType: .currentUser, otherUserId: user.id)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }

    private func pushSettingsViewController() {
        navigationController?.pushViewController(SettingsViewController(user: user), animated: true)
    }

    private func pushMessagingViewController() {
        navigationController?.pushViewController(MessagesViewController(user: user), animated: true)
    }

}

extension ProfileMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuOptionTableViewCell.reuseIdentifier,
                                                       for: indexPath) as?
            MenuOptionTableViewCell else { return UITableViewCell() }
        let option = menuOptions[indexPath.row]
        cell.configure(for: option)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = menuOptions[indexPath.row]
        if option.text == "Your Profile" {
            pushEditingProfileViewController()
        } else if option.text == "Settings" {
            pushSettingsViewController()
        } else if option.text == "Messages" {
            pushMessagingViewController()
        }
    }

}

extension ProfileMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

}

extension ProfileMenuViewController: EditDemographicsViewControllerDelegate {
    
    func didUpdateProfilePicture(image: UIImage?, url: String) {
        delegate?.didUpdateProfilePicture(image: image, url: url)
    }
    
}
