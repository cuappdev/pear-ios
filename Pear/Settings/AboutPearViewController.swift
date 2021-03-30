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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Pear"

        backgroundImage.image = UIImage(named: "settingsBackground")
        backgroundImage.contentMode =  .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)

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
        aboutTableView.backgroundColor = .clear
        aboutTableView.bounces = false
        aboutTableView.register(AboutPearTableViewCell.self, forCellReuseIdentifier: AboutPearTableViewCell.reuseIdentifier)
        view.addSubview(aboutTableView)

        feedbackButton.setTitle("Send Feedback", for: .normal)
        feedbackButton.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
        setButtonAppearance(button: feedbackButton)
        view.addSubview(feedbackButton)

        visitWebsiteButton.setTitle("Visit our Website", for: .normal)
        visitWebsiteButton.addTarget(self, action: #selector(visitWebsite), for: .touchUpInside)
        setButtonAppearance(button: visitWebsiteButton)
        view.addSubview(visitWebsiteButton)

        moreAppsButton.setTitle("More Apps", for: .normal)
        moreAppsButton.addTarget(self, action: #selector(presentMoreApps), for: .touchUpInside)
        setButtonAppearance(button: moreAppsButton)
        view.addSubview(moreAppsButton)

        setupConstraints()
        setupNavigationBar()
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
    }

    private func setButtonAppearance(button: UIButton) {
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = ._16CircularStdBook
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
    }

    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func sendFeedback() {
        if let url = URL(string: Keys.feedbackURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc private func visitWebsite() {
        let websiteURL = "https://www.cornellappdev.com/"
        if let url = URL(string: websiteURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc private func presentMoreApps() {
        let moreAppsURL = "https://www.cornellappdev.com/apps/"
        if let url = URL(string: moreAppsURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func setupConstraints() {
        aboutLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(view.snp.top).offset(125)
        }

        aboutTableView.snp.makeConstraints { make in
            make.top.equalTo(aboutLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).inset(250)
        }

        feedbackButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(aboutTableView.snp.bottom).offset(30)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }

        visitWebsiteButton.snp.makeConstraints { make in
            make.centerX.height.width.equalTo(feedbackButton)
            make.top.equalTo(feedbackButton.snp.bottom).offset(12)
        }

        moreAppsButton.snp.makeConstraints { make in
            make.centerX.width.height.equalTo(feedbackButton)
            make.top.equalTo(visitWebsiteButton.snp.bottom).offset(12)
        }
    }

}

extension AboutPearViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        aboutParagraphs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = aboutTableView.dequeueReusableCell(withIdentifier: AboutPearTableViewCell.reuseIdentifier, for: indexPath) as? AboutPearTableViewCell else { return UITableViewCell() }
        let paragraph = aboutParagraphs[indexPath.row]
        cell.configure(for: paragraph)
        return cell
    }

}

extension AboutPearViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }

}
