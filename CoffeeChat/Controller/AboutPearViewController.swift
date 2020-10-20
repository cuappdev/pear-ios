//
//  AboutPearViewController.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/11/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class AboutPearViewController: UIViewController {
    
    // MARK: - Private View Vars
    private let aboutLabel = UILabel()
    private let aboutTableView = UITableView()
    private let backButton = UIButton()
    private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    private let feedbackButton = UIButton()
    private let moreAppsButton = UIButton()
    private let settingsTableView = UITableView()
    private let visitWebsiteButton = UIButton()
    
    // MARK: - Private Data Vars
    private let aboutParagraphs: [AboutParagraph] = [
        AboutParagraph(bold: "Get paired ", regular: "up with a new Cornell student like you, every week"),
        AboutParagraph(bold: "Reach out ", regular: "by sending over when and where you prefer, or choose from what your pair suggested."),
        AboutParagraph(bold: "Meet at ", regular: "the chosen time and place, and now you have one new friend at Cornell!"),
        AboutParagraph(bold: "", regular: "You can pause pairings at any time in Settings.")
    ]
    let aboutReuseId = "aboutReuseId"
    private var backgroundXPosition: CGFloat = UIScreen.main.bounds.width
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About Pear"
        
        backgroundImage.image = UIImage(named: "aboutPearBackground")
        backgroundImage.contentMode =  .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        aboutLabel.text = "Pear was created to help Cornell\nstudents meet new people and\nform meaningful connections."
        aboutLabel.textAlignment = .center
        aboutLabel.font = UIFont.getFont(.medium, size: 20)
        aboutLabel.numberOfLines = 0
        view.addSubview(aboutLabel)
        
        aboutTableView.separatorStyle = .none
        aboutTableView.allowsSelection = false
        aboutTableView.showsVerticalScrollIndicator = false
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
        aboutTableView.backgroundColor = .backgroundLightGreen
        aboutTableView.isScrollEnabled = false
        aboutTableView.register(AboutPearTableViewCell.self, forCellReuseIdentifier: aboutReuseId)
        view.addSubview(aboutTableView)
        
        feedbackButton.layer.cornerRadius = 8
        feedbackButton.setTitle("Send Feedback", for: .normal)
        feedbackButton.setTitleColor(.black, for: .normal)
        feedbackButton.titleLabel?.font = ._16CircularStdBook
        feedbackButton.backgroundColor = .white
        feedbackButton.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
        setShadow(button: feedbackButton)
        view.addSubview(feedbackButton)
        
        visitWebsiteButton.layer.cornerRadius = 8
        visitWebsiteButton.setTitle("Visit our Website", for: .normal)
        visitWebsiteButton.setTitleColor(.black, for: .normal)
        visitWebsiteButton.titleLabel?.font = ._16CircularStdBook
        visitWebsiteButton.backgroundColor = .white
        visitWebsiteButton.addTarget(self, action: #selector(visitWebsite), for: .touchUpInside)
        setShadow(button: visitWebsiteButton)
        view.addSubview(visitWebsiteButton)
        
        moreAppsButton.layer.cornerRadius = 8
        moreAppsButton.setTitle("More Apps", for: .normal)
        moreAppsButton.setTitleColor(.black, for: .normal)
        moreAppsButton.titleLabel?.font = ._16CircularStdBook
        moreAppsButton.backgroundColor = .white
        moreAppsButton.addTarget(self, action: #selector(presentMoreApps), for: .touchUpInside)
        setShadow(button: moreAppsButton)
        view.addSubview(moreAppsButton)
        
        setupConstraints()
        setupNavigationBar()
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
    
    private func setShadow(button: UIButton) {
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
    }
    
    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sendFeedback() {
        // Todo
    }
    
    @objc private func visitWebsite() {
        // Todo
    }
    
    @objc private func presentMoreApps() {
        // Todo
    }
    
    private func setupConstraints() {
        aboutLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(view.snp.top).offset(125)
        }
        aboutTableView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-290)
        }
        feedbackButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(aboutTableView.snp.bottom).offset(10)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        visitWebsiteButton.snp.makeConstraints { (make) in
            make.centerX.height.width.equalTo(feedbackButton)
            make.top.equalTo(feedbackButton.snp.bottom).offset(12)
        }
        moreAppsButton.snp.makeConstraints { (make) in
            make.centerX.width.height.equalTo(feedbackButton)
            make.top.equalTo(visitWebsiteButton.snp.bottom).offset(12)
        }
    }

}

extension AboutPearViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        aboutParagraphs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = aboutTableView.dequeueReusableCell(withIdentifier: aboutReuseId, for: indexPath) as? AboutPearTableViewCell else { return UITableViewCell() }
        let paragraph = aboutParagraphs[indexPath.row]
        cell.configure(for: paragraph)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }
}
