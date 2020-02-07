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
    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let nextButton = UIButton()
    private let backButton = UIButton()

    // MARK: - Gradients
    // Fade out affects on the top and bottom of the tableView
    private let topFade = UIView()
    private let bottomFade = UIView()

    // MARK: - Data
    private var interestData: [Interest] = []
    private var selectedInterests: [Interest] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundWhite

        titleLabel.text = "What are your interests?"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(titleLabel)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InterestsTableViewCell.self, forCellReuseIdentifier: InterestsTableViewCell.reuseIdentifier)
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.allowsMultipleSelection = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        tableView.contentInset = insets
        view.addSubview(tableView)
        view.addSubview(topFade)
        view.addSubview(bottomFade)

        nextButton.setTitle("Almost there!", for: .normal)
        nextButton.layer.cornerRadius = 27
        nextButton.backgroundColor = .backgroundLightGray
        nextButton.setTitleColor(.textBlack, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        view.addSubview(nextButton)

        backButton.titleLabel?.font = .systemFont(ofSize: 16)
        backButton.setTitle("Go back", for: .normal)
        backButton.setTitleColor(.textLightGray, for: .normal)
        backButton.backgroundColor = .none
        view.addSubview(backButton)

        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        let clearColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)

        let topLayer = CAGradientLayer()
        topLayer.frame = topFade.bounds
        topLayer.colors = [UIColor.backgroundWhite.cgColor, clearColor.cgColor]
        topLayer.locations = [0.0, 1.0]
        topFade.layer.insertSublayer(topLayer, at: 0)

        let bottomLayer = CAGradientLayer()
        bottomLayer.frame = bottomFade.bounds
        bottomLayer.colors = [clearColor.cgColor, UIColor.backgroundWhite.cgColor]
        bottomLayer.locations = [0.0, 1.0]
        bottomFade.layer.insertSublayer(bottomLayer, at: 0)
    }

    private func setupConstraints() {
        let titleSpacing: CGFloat = 100
        let titleHeight: CGFloat = 30
        let tableViewSize = CGSize(width: 295, height: 431)
        let tableViewTopPadding: CGFloat = 50
        let nextButtonSize = CGSize(width: 225, height: 54)
        let nextTopPadding: CGFloat = 56
        let nextBackPadding: CGFloat = 20
        let backSize = CGSize(width: 62, height: 20)
        let fadeHeight: CGFloat = 26
        let topFadeHeight: CGFloat = 10

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(titleSpacing)
        }

        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(tableViewSize)
            make.top.equalTo(titleLabel.snp.bottom).offset(tableViewTopPadding)
        }

        topFade.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(tableView)
            make.height.equalTo(topFadeHeight)
        }

        bottomFade.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(tableView)
            make.height.equalTo(fadeHeight)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom).offset(nextTopPadding)
        }

        backButton.snp.makeConstraints { make in
            make.size.equalTo(backSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(nextButton.snp.bottom).offset(nextBackPadding)
        }
    }

    /**
     Updates the enabled state of next button based on the state of selectedInterests.
     */
    private func updateNext() {
        nextButton.isEnabled = selectedInterests.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundRed : .backgroundLightGray
    }

}

// MARK: TableViewDelegate
extension InterestsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterests.append(interestData[indexPath.section])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedInterests.removeAll { $0.name == interestData[indexPath.section].name}
        updateNext()
    }

}

// MARK: TableViewDataSource
extension InterestsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            InterestsTableViewCell.reuseIdentifier, for: indexPath) as?
        InterestsTableViewCell else { return UITableViewCell() }
        let data = interestData[indexPath.section]
        cell.configure(with: data)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return interestData.count
    }

}
