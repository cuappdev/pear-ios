//
//  GoalsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 9/16/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import SnapKit
import UIKit

class GoalsViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?
    // TODO: change when networking with backend
    private var goals: [SimpleOnboardingCell] = [
        SimpleOnboardingCell(name: "Just chatting", subtitle: nil),
        SimpleOnboardingCell(name: "Finding my people", subtitle: nil),
        SimpleOnboardingCell(name: "Meeting someone different", subtitle: nil),
        SimpleOnboardingCell(name: "Learning from mentors", subtitle: nil),
        SimpleOnboardingCell(name: "Guiding mentees", subtitle: nil),
        SimpleOnboardingCell(name: "Not sure yet", subtitle: nil)
    ]
    private var selectedGoals: [String] = []

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let nextButton = UIButton()
    private let skipButton = UIButton()
    private let subtitleLabel = UILabel()
    private let tableView = UITableView()
    private let titleLabel = UILabel()

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
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.register(SimpleOnboardingTableViewCell.self,
                           forCellReuseIdentifier: SimpleOnboardingTableViewCell.reuseIdentifier)
        view.addSubview(tableView)

        titleLabel.text = "How do you want to use\nPear?"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        subtitleLabel.text = "Pick as many as you'd like"
        subtitleLabel.textColor = .greenGray
        subtitleLabel.font = ._12CircularStdBook
        view.addSubview(subtitleLabel)

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = 26
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        skipButton.titleLabel?.font = ._16CircularStdMedium
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.greenGray, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        view.addSubview(skipButton)

        getUserGoals()
        setupConstraints()
    }

    private func setupConstraints() {
        let backSize = CGSize(width: 86, height: 20)
        let tableViewBottomPadding: CGFloat = 57
        let tableViewTopPadding: CGFloat = 24
        let titleSize = CGSize(width: 318, height: 61)

        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(6)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(titleSize)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(tableViewTopPadding)
            make.bottom.equalTo(nextButton.snp.top).offset(-tableViewBottomPadding)
            make.leading.trailing.equalToSuperview().inset(40)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }

        skipButton.snp.makeConstraints { make in
            make.size.equalTo(backSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.skipBottomPadding)
        }
    }

    // MARK: - Next and Previous Buttons
    private func updateNext() {
        nextButton.isEnabled = selectedGoals.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
        skipButton.isEnabled = !nextButton.isEnabled
        let skipButtonColor: UIColor = skipButton.isEnabled ? .greenGray : .inactiveGreen
        skipButton.setTitleColor(skipButtonColor, for: .normal)
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 2)
    }

    @objc func nextButtonPressed() {
        NetworkManager.shared.updateUserGoals(goals: selectedGoals).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        self.delegate?.nextPage(index: 4)
                    } else {
                        self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                    }
                case .error:
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
    }

    @objc func skipButtonPressed() {
        delegate?.nextPage(index: 4)
    }

    private func getUserGoals() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getUser(netId: netId).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        let userGoals = response.data.goals
                        self.selectedGoals = userGoals
                        self.tableView.reloadData()
                        self.updateNext()
                    } else {
                        print("Network error: could not get user goals.")
                    }
                case .error:
                    print("Network error: could not get user goals.")
                }
            }
        }
    }
}

// MARK: TableViewDelegate
extension GoalsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        goals.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = goals[indexPath.row]
        selectedGoals.append(goal.name)
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let goal = goals[indexPath.row]
        selectedGoals.removeAll { $0 == goal.name }
        updateNext()
    }

}

// MARK: TableViewDataSource
extension GoalsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleOnboardingTableViewCell.reuseIdentifier,
                                                       for: indexPath) as?
                SimpleOnboardingTableViewCell else { return UITableViewCell() }
        let goal = goals[indexPath.row]
        cell.configure(with: goal)
        if selectedGoals.contains(where: { $0 == goal.name }) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }

}
