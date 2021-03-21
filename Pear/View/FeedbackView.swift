//
//  FeedbackView.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/21/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class FeedbackView: UIView {

    // MARK: - Private View Vars
    private let feedbackTableView = UITableView()

    // MARK: - Private Data Vars
    private let feedbackOptions = ["Send feedback", "Contact us", "Report user"]

    init() {
        super.init(frame: .zero)
        setUpViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        feedbackTableView.backgroundColor = .backgroundWhite
        feedbackTableView.separatorStyle = .none
        feedbackTableView.showsVerticalScrollIndicator = false
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.register(FeedbackMenuTableViewCell.self, forCellReuseIdentifier: FeedbackMenuTableViewCell.reuseIdentifier)
        addSubview(feedbackTableView)
    }

    private func setupConstraints() {
        feedbackTableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}

extension FeedbackView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedbackOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = feedbackTableView.dequeueReusableCell(withIdentifier: FeedbackMenuTableViewCell.reuseIdentifier, for: indexPath) as? FeedbackMenuTableViewCell else { return UITableViewCell() }
        let feedbackOption = feedbackOptions[indexPath.row]
        cell.configure(for: feedbackOption)
        return cell
    }


}

extension FeedbackView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionSelected = feedbackOptions[indexPath.row]
        if (optionSelected == "Send feedback") {
            let feedbackURL = "https://forms.gle/t9umWjckEs4NNWNS8/"
            if let url = URL(string: feedbackURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            let email = "cornellappdev@gmail.com"
            let emailSubject = optionSelected == "Contact us" ? "Pear%20Feedback" : "Report%20User"
            URLScheme.openGmail(to: email, subject: emailSubject)
        }
    }
}
