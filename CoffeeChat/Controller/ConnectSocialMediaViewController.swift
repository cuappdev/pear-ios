//
//  ConnectSocialMediaViewController.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/18/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class ConnectSocialMediaViewController: UIViewController {
    
    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    private let saveBarButtonItem = UIBarButtonItem()
    private let infoTextView = UITextView()
    private let instaTextField = UITextField()
    private let fbTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        setupNavigationBar()
        
        backgroundImage.image = UIImage(named: "aboutPearBackground")
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
        
        // fill with previously saved socials from backend
        instaTextField.text = "@cndyhuang"
        instaTextField.font = ._20CircularStdBook
        instaTextField.backgroundColor = .white
        instaTextField.layer.cornerRadius = 8
        instaTextField.textColor = .textBlack
        instaTextField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        instaTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        instaTextField.layer.shadowOpacity = 1
        instaTextField.layer.shadowRadius = 4
        view.addSubview(instaTextField)
        
        
        let instaicon = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        instaicon.image = UIImage(named: "instaicon")
        let instaViewL = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        instaViewL.addSubview(instaicon)
        instaTextField.leftView = instaViewL
        instaTextField.leftViewMode = .always
        
        let instaViewR = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        instaTextField.rightView = instaViewR
        instaTextField.rightViewMode = .always
        
        // fill with previously saved socials from backend
        fbTextField.text = "http://www.facebook.co..."
        fbTextField.font = ._20CircularStdBook
        fbTextField.textColor = .textBlack
        fbTextField.backgroundColor = .white
        fbTextField.layer.cornerRadius = 8
        fbTextField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        fbTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        fbTextField.layer.shadowOpacity = 1
        fbTextField.layer.shadowRadius = 4
        view.addSubview(fbTextField)
        
        let fbicon = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        fbicon.image = UIImage(named: "facebookicon")
        let facebookViewL = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        facebookViewL.addSubview(fbicon)
        fbTextField.leftView = facebookViewL
        fbTextField.leftViewMode = .always
        
        let facebookViewR = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        fbTextField.rightView = facebookViewR
        fbTextField.rightViewMode = .always
        
        
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
        
        saveBarButtonItem.title = "Save"
        saveBarButtonItem.tintColor = .darkGreen
        saveBarButtonItem.target = self
        saveBarButtonItem.action = #selector(saveAvailability)
        saveBarButtonItem.setTitleTextAttributes([
            .font: UIFont.getFont(.medium, size: 20)
        ], for: .normal)
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveAvailability() {
        print("saving")
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        infoTextView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(63)
            make.height.equalTo(90)
        }
        
        instaTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoTextView.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        fbTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(instaTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
    }
 
}
