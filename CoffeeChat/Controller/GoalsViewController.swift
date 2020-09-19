//
//  GoalsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 9/16/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class GoalsViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?
    private var selectedGoals: [String] = []

    // TODO: change when networking with backend
    private var goals: [String] = [
        "Chatting with someone new",
        "Finding new friends",
        "Getting outside of my comfort zone",
        "Getting advice",
        "Giving advice",
        "Not sure yet"
    ]
    private let userDefaults = UserDefaults.standard

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let nextButton = UIButton()
    private let skipButton = UIButton()
    private let tableView = UITableView()

    init(delegate: OnboardingPageDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .none
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(GoalTableViewCell.self, forCellReuseIdentifier: GoalTableViewCell.reuseIdentifier)
        view.addSubview(tableView)

        titleLabel.text = "How can Pear help you?"
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = 26
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        skipButton.titleLabel?.font = ._16CircularStdMedium
        skipButton.setTitle("I'll add later", for: .normal)
        skipButton.setTitleColor(.greenGray, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        view.addSubview(skipButton)

        setupConstraints()
    }

    private func setupConstraints() {
        let backButtonSize = CGSize(width: 10, height: 18)
        let backSize = CGSize(width: 86, height: 20)
        let skipBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 24)
        let nextBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 67)
        let nextButtonSize = CGSize(width: 225, height: 54)
        let tableViewWidth: CGFloat = 295
        let tableViewBottomPadding: CGFloat = 57
        let tableViewTopPadding: CGFloat = 24
        let titleHeight: CGFloat = 30
        let titleSpacing: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 64)

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleSpacing)
        }

        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(tableViewWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(tableViewTopPadding)
            make.bottom.equalTo(nextButton.snp.top).offset(-tableViewBottomPadding)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextBottomPadding)
        }

        skipButton.snp.makeConstraints { make in
            make.size.equalTo(backSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(skipBottomPadding)
        }
    }


    // MARK: - Next and Previous Buttons
    /// Updates the enabled state of next button based on the state of selectedGroups.
    private func updateNext() {
        nextButton.isEnabled = selectedGoals.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 2)
    }

    @objc func nextButtonPressed() {
        userDefaults.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }

    @objc func skipButtonPressed() {
        userDefaults.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }

}

// MARK: TableViewDelegate
extension GoalsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGoals.append(goals[indexPath.row])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedGoals.removeAll { $0 == goals[indexPath.row]}
        updateNext()
    }

}

// MARK: TableViewDataSource
extension GoalsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
        GoalTableViewCell.reuseIdentifier, for: indexPath) as?
        GoalTableViewCell else { return UITableViewCell() }
        let data = goals[indexPath.row]
        cell.configure(with: data)
        return cell
    }

}

