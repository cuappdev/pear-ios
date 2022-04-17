//
//  OptionsView.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/21/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//
import UIKit

protocol FeedbackDelegate: AnyObject {
    func presentActionSheet(alert: UIAlertController)
}

protocol BlockDelegate: AnyObject {
    func didBlockOrUnblockUser()
    func presentErrorAlert()
}

class OptionsView: UIView {

    // MARK: - Private View Vars
    private var arrowBackgroundView = UIView()
    private var arrowView = UIView()
    private let optionsTableView = UITableView()
    private let optionsBackgroundView = UIView()
    private var superView = UIView()
    private weak var feedbackDelegate: FeedbackDelegate?
    private weak var blockDelegate: BlockDelegate?

    // MARK: - Private Data Vars
    private var matchId: Int?
    private var blockId: Int?
    private var options = ["Send feedback", "Contact us", "Report user", "Block user"]
    private let size = 20
    private let reuseIdentifier = "FeedbackMenuTableViewCell"

    init(feedbackDelegate: FeedbackDelegate?, blockDelegate: BlockDelegate?, matchId: Int, blockId: Int, options: [String], superView: UIView) {
        self.feedbackDelegate = feedbackDelegate
        self.blockDelegate = blockDelegate
        self.matchId = matchId
        self.blockId = blockId
        self.options = options
        self.superView = superView
        
        super.init(frame: .zero)
        setUpViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setOptions(options: [String]) {
        self.options = options
        optionsTableView.reloadData()
    }

    private func setUpViews() {
        layer.cornerRadius = 20
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

        optionsBackgroundView.backgroundColor = .white
        addSubview(optionsBackgroundView)

        optionsTableView.backgroundColor = .backgroundWhite
        optionsTableView.separatorStyle = .none
        optionsTableView.showsVerticalScrollIndicator = false
        optionsTableView.rowHeight = 40
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.isScrollEnabled = false
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        optionsBackgroundView.addSubview(optionsTableView)
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
        optionsBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(arrowBackgroundView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        optionsTableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}

extension OptionsView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = ._16CircularStdBook
        cell.selectionStyle = .none
        cell.textLabel?.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return cell
    }

}

extension OptionsView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionSelected = options[indexPath.row]
        if optionSelected == "Send feedback" {
            if let url = URL(string: Keys.feedbackURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else if optionSelected == "Block user" {
            guard let blockId = blockId else { return }
            let blockUserView = BlockUserView(blockDelegate: blockDelegate, userId: blockId, isBlocking: true)
            Animations.presentPopUpView(superView: superView, popUpView: blockUserView)
        } else {
            let emailSubject = optionSelected == "Contact us" ? "Pear Feedback" : "Report User"
            let emailAlertController = UIAlertController.getEmailAlertController(
                email: Keys.feedbackEmail,
                subject: emailSubject
            )
            feedbackDelegate?.presentActionSheet(alert: emailAlertController)
        }
    }

}
