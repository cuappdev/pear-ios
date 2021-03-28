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
    private var arrowBackgroundView = UIView()
    private var arrowView = UIView()
    private let feedbackTableView = UITableView()
    private let feedbackBackgroundView = UIView()

    // MARK: - Private Data Vars
    private let feedbackOptions = ["Send feedback", "Contact us", "Report user"]
    private let size = 20

    init() {
        super.init(frame: .zero)
        setUpViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        arrowBackgroundView.backgroundColor = .clear
        addSubview(arrowBackgroundView)

        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: size))
        path.addLine(to: CGPoint(x:size/2, y: size/2))
        path.addLine(to: CGPoint(x:size, y:size))
        path.addLine(to: CGPoint(x:0, y:size))
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.white.cgColor
        arrowView.layer.insertSublayer(shape, at: 0)
        arrowBackgroundView.addSubview(arrowView)

        feedbackBackgroundView.backgroundColor = .white
        addSubview(feedbackBackgroundView)

        feedbackTableView.backgroundColor = .backgroundWhite
        feedbackTableView.separatorStyle = .none
        feedbackTableView.showsVerticalScrollIndicator = false
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.isScrollEnabled = false
        feedbackTableView.register(FeedbackMenuTableViewCell.self, forCellReuseIdentifier: FeedbackMenuTableViewCell.reuseIdentifier)
        feedbackBackgroundView.addSubview(feedbackTableView)
    }

    private func setupConstraints() {
        arrowBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(size/2)
        }
        arrowView.snp.makeConstraints { make in
            make.trailing.equalTo(arrowBackgroundView.snp.trailing)
            make.bottom.equalTo(arrowBackgroundView.snp.bottom)
            make.width.equalTo(size)
            make.height.equalTo(size)
        }
        feedbackBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(arrowBackgroundView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        feedbackTableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(feedbackBackgroundView)
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
        if optionSelected == "Send feedback" {
            let feedbackURL = Keys.feedbackURL
            if let url = URL(string: feedbackURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            let email = "team@cornellappdev.com"
            let emailSubject = optionSelected == "Contact us" ? "Pear%20Feedback" : "Report%20User"
            URLScheme.openGmail(to: email, subject: emailSubject)
        }
    }

}