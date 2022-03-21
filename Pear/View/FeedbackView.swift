//
//  FeedbackView.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/21/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//
import UIKit

protocol FeedbackDelegate: AnyObject {
    func presentActionSheet(alert: UIAlertController)
    func presentBlockUserView(blockUserView: BlockUserView)
    func removeBlockUserView(blockUserView: BlockUserView)
    func blockUser(userId: Int)
    func unblockUser(userId: Int)
}

class FeedbackView: UIView {

    // MARK: - Private View Vars
    private var arrowBackgroundView = UIView()
    private var arrowView = UIView()
    private let feedbackTableView = UITableView()
    private let feedbackBackgroundView = UIView()
    private weak var delegate: FeedbackDelegate?

    // MARK: - Private Data Vars
    private var matchId: Int?
    private var feedbackOptions = ["Send feedback", "Contact us", "Report user", "Block user"]
    private let size = 20
    private let reuseIdentifier = "FeedbackMenuTableViewCell"

    init(delegate: FeedbackDelegate, matchId: Int, feedbackOptions: [String]) {
        self.delegate = delegate
        self.matchId = matchId
        self.feedbackOptions = feedbackOptions
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
        feedbackTableView.rowHeight = 40
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.isScrollEnabled = false
        feedbackTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        feedbackBackgroundView.addSubview(feedbackTableView)
    }

    private func setupConstraints() {
        arrowBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(size/2)
        }
        arrowView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.equalTo(size)
            make.height.equalTo(size)
        }
        feedbackBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(arrowBackgroundView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
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
        let cell = feedbackTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = feedbackOptions[indexPath.row]
        cell.textLabel?.font = ._16CircularStdBook
        cell.selectionStyle = .none
        cell.textLabel?.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return cell
    }

}

extension FeedbackView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionSelected = feedbackOptions[indexPath.row]
        if optionSelected == "Send feedback" {
            if let url = URL(string: Keys.feedbackURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        else if optionSelected == "Block user" {
            guard let delegate = delegate, let matchId = matchId else { return }
            let blockUserView = BlockUserView(delegate: delegate, userId: matchId)
            delegate.presentBlockUserView(blockUserView: blockUserView)
        }
        else {
            let emailSubject = optionSelected == "Contact us" ? "Pear Feedback" : "Report User"
            let emailAlertController = UIAlertController.getEmailAlertController(
                email: Keys.feedbackEmail,
                subject: emailSubject
            )
            delegate?.presentActionSheet(alert: emailAlertController)
        }
    }

}
