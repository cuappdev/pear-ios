//
//  EditSocialMediaViewController.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/18/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class EditSocialMediaViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    private let fbTextField = UITextField()
    private let infoTextView = UITextView()
    private let instaTextField = UITextField()
    private let saveBarButtonItem = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        setupNavigationBar()

        backgroundImage.image = UIImage(named: "settingsBackground")
        backgroundImage.contentMode =  .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

        title = "Social Media"

        infoTextView.text = "Help your Pear contact you by connecting your social media accounts. Your information will only be shared with the verified Cornell students you are paired with."
        infoTextView.textAlignment = .center
        infoTextView.textColor = .greenGray
        infoTextView.backgroundColor = .clear
        infoTextView.font = UIFont.getFont(.book, size: 14)
        infoTextView.isEditable = false
        infoTextView.isScrollEnabled = false
        view.addSubview(infoTextView)

        instaTextField.text = ""
        instaTextField.placeholder = "@Instagram handle"
        instaTextField.font = ._20CircularStdBook
        instaTextField.backgroundColor = .white
        instaTextField.layer.cornerRadius = 8
        instaTextField.textColor = .black
        instaTextField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        instaTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        instaTextField.layer.shadowOpacity = 1
        instaTextField.layer.shadowRadius = 4
        instaTextField.clearButtonMode = .whileEditing
        view.addSubview(instaTextField)

        let instaIcon = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        instaIcon.image = UIImage(named: "instagram")
        let instaViewL = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        instaViewL.addSubview(instaIcon)
        instaTextField.leftView = instaViewL
        instaTextField.leftViewMode = .always

        fbTextField.text = ""
        fbTextField.placeholder = "Facebook profile link"
        fbTextField.font = ._20CircularStdBook
        fbTextField.textColor = .black
        fbTextField.backgroundColor = .white
        fbTextField.clearButtonMode = .whileEditing
        fbTextField.layer.cornerRadius = 8
        fbTextField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        fbTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        fbTextField.layer.shadowOpacity = 1
        fbTextField.layer.shadowRadius = 4
        view.addSubview(fbTextField)

        let fbIcon = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        fbIcon.image = UIImage(named: "facebook")
        let facebookViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        facebookViewLeft.addSubview(fbIcon)
        fbTextField.leftView = facebookViewLeft
        fbTextField.leftViewMode = .always

        setupConstraints()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(.medium, size: 24)
        ]

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.backButtonSize)
        }
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        saveBarButtonItem.title = "Save"
        saveBarButtonItem.tintColor = .darkGreen
        saveBarButtonItem.target = self
        saveBarButtonItem.action = #selector(saveSocialMedia)
        saveBarButtonItem.setTitleTextAttributes([
            .font: UIFont.getFont(.medium, size: 20)
        ], for: .normal)
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveSocialMedia() {
        Networking2.updateSocialMedia(
            facebookUrl: fbTextField.text,
            instagramUsername: instaTextField.text,
            hasOnboarded: true
        ) { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserSocialMedia()
        super.viewDidAppear(animated)
    }
    
    private func getUserSocialMedia() {
        Networking2.getMe { [weak self] user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.fbTextField.text = user.facebookUrl
                self.instaTextField.text = user.instagramUsername
            }
        }
    }

    private func setupConstraints() {
        infoTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(63)
            make.height.equalTo(110)
        }

        instaTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoTextView.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }

        fbTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(instaTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }

    }

}
