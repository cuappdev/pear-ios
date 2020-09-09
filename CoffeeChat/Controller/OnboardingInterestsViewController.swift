//
//  OnboardingInterestsViewController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/3/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class OnboardingInterestsViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let nextButton = UIButton()
    private let tableView = FadedTableView(frame: .zero, style: .plain)
    private let titleLabel = UILabel()

    // MARK: - Gradients
    // Fade out affects on the top and bottom of the tableView
    private let bottomFadeView = UIView()
    private let topFadeView = UIView()

    // MARK: - Data
    private var delegate: OnboardingPageDelegate
    private var interests: [Interest] = [
        Interest(name: "Art", categories: "lorem, lorem, lorem, lorem, lorem", image: "art"),
        Interest(name: "Business", categories: "lorem, lorem, lorem, lorem, lorem", image: "business"),
        Interest(name: "Dance", categories: "lorem, lorem, lorem, lorem, lorem", image: "dance"),
        Interest(name: "Design", categories: "lorem, lorem, lorem, lorem, lorem", image: "design"),
        Interest(name: "Fashion", categories: "lorem, lorem, lorem, lorem, lorem", image: "fashion"),
        Interest(name: "Fitness", categories: "lorem, lorem, lorem, lorem, lorem", image: "fitness"),
        Interest(name: "Food", categories: "lorem, lorem, lorem, lorem, lorem", image: "food"),
        Interest(name: "Humanities", categories: "lorem, lorem, lorem, lorem, lorem", image: "humanities"),
        Interest(name: "Music", categories: "lorem, lorem, lorem, lorem, lorem", image: "music"),
        Interest(name: "Photography", categories: "lorem, lorem, lorem, lorem, lorem", image: "photography"),
        Interest(name: "Reading", categories: "lorem, lorem, lorem, lorem, lorem", image: "reading"),
        Interest(name: "Sustainability", categories: "lorem, lorem, lorem, lorem, lorem", image: "sustainability"),
        Interest(name: "Technology", categories: "lorem, lorem, lorem, lorem, lorem", image: "tech"),
        Interest(name: "Travel", categories: "lorem, lorem, lorem, lorem, lorem", image: "travel"),
        Interest(name: "TV & Film", categories: "lorem, lorem, lorem, lorem, lorem", image: "tvfilm")
    ]
    private var selectedInterests: [Interest] = []

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

        titleLabel.text = "What do you love?"
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.backgroundColor = .none
        tableView.allowsMultipleSelection = true
        tableView.bounces = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        view.addSubview(tableView)
        view.addSubview(topFadeView)
        view.addSubview(bottomFadeView)

        nextButton.setTitle("Almost there", for: .normal)
        nextButton.layer.cornerRadius = 27
        nextButton.isEnabled = false
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        setupConstraints()
    }

    @objc func nextButtonPressed() {
        delegate.nextPage(index: 2)
    }

    override func viewDidAppear(_ animated: Bool) {
        setupTableViewFadeEffect()
    }

    private func setupTableViewFadeEffect() {
        let clearColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)
        let fadeColors = [UIColor.backgroundLightGreen.cgColor, clearColor.cgColor]

        let topLayer = CAGradientLayer()
        topLayer.frame = topFadeView.bounds
        topLayer.colors = fadeColors
        topLayer.locations = [0.0, 1.0]
        topFadeView.layer.insertSublayer(topLayer, at: 0)

        let bottomLayer = CAGradientLayer()
        bottomLayer.frame = bottomFadeView.bounds
        bottomLayer.colors = fadeColors.reversed()
        bottomLayer.locations = [0.0, 1.0]
        bottomFadeView.layer.insertSublayer(bottomLayer, at: 0)
    }

    private func setupConstraints() {
        let fadeHeight: CGFloat = 26
        let nextButtonSize = CGSize(width: 225, height: 54)
        let nextBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 90)
        let tableViewWidth: CGFloat = 295
        let tableViewBottomPadding: CGFloat = 57
        let tableViewTopPadding: CGFloat = 50
        let titleHeight: CGFloat = 30
        let titleSpacing: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 100)
        let topFadeHeight: CGFloat = 10

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

        topFadeView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(tableView)
            make.height.equalTo(topFadeHeight)
        }

        bottomFadeView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(tableView)
            make.height.equalTo(fadeHeight)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextBottomPadding)
        }
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
extension OnboardingInterestsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterests.append(interests[indexPath.row])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedInterests.removeAll { $0.name == interests[indexPath.row].name}
        updateNext()
    }

}

// MARK: TableViewDataSource
extension OnboardingInterestsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            OnboardingTableViewCell.reuseIdentifier, for: indexPath) as?
        OnboardingTableViewCell else { return UITableViewCell() }
        let data = interests[indexPath.row]
        cell.configure(with: data)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return interests.count
    }

}
