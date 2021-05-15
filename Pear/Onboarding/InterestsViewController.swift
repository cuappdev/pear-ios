//
//  InterestsViewController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/3/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class InterestsViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let nextButton = UIButton()
    private let fadeTableView = FadeWrapperView(
        UITableView(frame: .zero, style: .plain),
        fadeColor: .backgroundLightGreen
    )
    private let titleLabel = UILabel()

    // MARK: - Data
    private weak var delegate: OnboardingPageDelegate?
    private let interests: [InterestV2] = [
        InterestV2(
            id: "1",
            name: "Art",
            subtitle: "art....",
            imgUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Circle-icons-art.svg/1024px-Circle-icons-art.svg.png")
    ]
    private var selectedInterests: [InterestV2] = []

    init(delegate: OnboardingPageDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        titleLabel.text = "What do you love?"
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        fadeTableView.view.allowsMultipleSelection = true
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
        fadeTableView.view.dataSource = self
        fadeTableView.view.delegate = self
        fadeTableView.view.bounces = true
        fadeTableView.view.keyboardDismissMode = .onDrag
        fadeTableView.view.register(OnboardingTableViewCell2.self, forCellReuseIdentifier: OnboardingTableViewCell2.reuseIdentifier)
        fadeTableView.view.separatorStyle = .none
        view.addSubview(fadeTableView)

        nextButton.setTitle("Next", for: .normal)
        nextButton.layer.cornerRadius = 27
        nextButton.isEnabled = false
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        getAllInterests()
//        getUserInterests()
        setupConstraints()
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 0)
    }

    @objc func nextButtonPressed() {
        delegate?.nextPage(index: 2)
        // TODO: Fill in network call
    }

    private func setupConstraints() {
        let tableViewTopPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 48)
        let tableViewBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 44)
        let titleHeight: CGFloat = 30

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }

        fadeTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
            make.top.equalTo(titleLabel.snp.bottom).offset(tableViewTopPadding)
            make.bottom.equalTo(nextButton.snp.top).offset(-tableViewBottomPadding)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }
    }

    private func getAllInterests() {

        Networking2.getAllInterests { interests in
            print("successful itnrests")
        }

    }

    private func getUserInterests() {
        //  TODO: Fill in network call
    }

    /// Updates the enabled state of next button based on the state of selectedInterests.
    private func updateNext() {
        nextButton.isEnabled = selectedInterests.count > 0
        if nextButton.isEnabled {
            nextButton.backgroundColor = .backgroundOrange
            nextButton.layer.shadowColor = UIColor.black.cgColor
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            nextButton.layer.shadowOpacity = 0.15
            nextButton.layer.shadowRadius = 2
        } else {
            nextButton.backgroundColor = .inactiveGreen
            nextButton.layer.shadowColor = .none
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            nextButton.layer.shadowOpacity = 0
            nextButton.layer.shadowRadius = 0
        }
    }

}

// MARK: TableViewDelegate
extension InterestsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interests.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterests.append(interests[indexPath.row])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedInterests.removeAll { $0.name == interests[indexPath.row].name }
        updateNext()
    }

}

// MARK: TableViewDataSource
extension InterestsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: OnboardingTableViewCell2.reuseIdentifier,
                for: indexPath
        ) as? OnboardingTableViewCell2 else { return UITableViewCell() }
        let data = interests[indexPath.row]
        cell.configure(with: data)
        if selectedInterests.contains(where: { $0.name == data.name }) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }

}
