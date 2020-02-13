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
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let titleLabel = UILabel()

    // MARK: - Gradients
    // Fade out affects on the top and bottom of the tableView
    private let bottomFadeView = UIView()
    private let topFadeView = UIView()

    // MARK: - Data
    private weak var delegate: OnboardingPageDelegate?
    private var interests: [Interest] = [
        Interest(name: "Aaaa", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "Bbbbbb", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "Cccc", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "Ddddddddd", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "Eeeeeeee", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "Ffff", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "GGGG", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "HHHH", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "IIII", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "KKdd", categories: "lorem, lorem, lorem, lorem, lorem", image: ""),
        Interest(name: "????", categories: "lorem, lorem, lorem, lorem, lorem", image: "")
    ]
    private var selectedInterests: [Interest] = []

    init(delegate: OnboardingPageDelegate) {
       super.init(nibName: nil, bundle: nil)
       self.delegate = delegate
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        view.addSubview(tableView)
        view.addSubview(topFadeView)
        view.addSubview(bottomFadeView)

        nextButton.setTitle("Almost there!", for: .normal)
        nextButton.layer.cornerRadius = 27
        nextButton.backgroundColor = .backgroundLightGray
        nextButton.setTitleColor(.textBlack, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        backButton.titleLabel?.font = .systemFont(ofSize: 16)
        backButton.setTitle("Go back", for: .normal)
        backButton.setTitleColor(.textLightGray, for: .normal)
        backButton.backgroundColor = .none
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        setupConstraints()
    }

    @objc func nextButtonPressed() {
        delegate?.nextPage(index: 2)
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        let clearColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)

        let topLayer = CAGradientLayer()
        topLayer.frame = topFadeView.bounds
        topLayer.colors = [UIColor.backgroundWhite.cgColor, clearColor.cgColor]
        topLayer.locations = [0.0, 1.0]
        topFadeView.layer.insertSublayer(topLayer, at: 0)

        let bottomLayer = CAGradientLayer()
        bottomLayer.frame = bottomFadeView.bounds
        bottomLayer.colors = [clearColor.cgColor, UIColor.backgroundWhite.cgColor]
        bottomLayer.locations = [0.0, 1.0]
        bottomFadeView.layer.insertSublayer(bottomLayer, at: 0)
    }

    private func setupConstraints() {
        let backSize = CGSize(width: 62, height: 20)
        let fadeHeight: CGFloat = 26
        let nextBackPadding: CGFloat = 20
        let nextButtonSize = CGSize(width: 225, height: 54)
        let nextTopPadding: CGFloat = 56
        let tableViewSize = CGSize(width: 295, height: 431)
        let tableViewTopPadding: CGFloat = 50
        let titleHeight: CGFloat = 30
        let titleSpacing: CGFloat = 100
        let topFadeHeight: CGFloat = 10

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleSpacing)
        }

        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(tableViewSize)
            make.top.equalTo(titleLabel.snp.bottom).offset(tableViewTopPadding)
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
        selectedInterests.append(interests[indexPath.section])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedInterests.removeAll { $0.name == interests[indexPath.section].name}
        updateNext()
    }

}

// MARK: TableViewDataSource
extension InterestsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            InterestsTableViewCell.reuseIdentifier, for: indexPath) as?
        InterestsTableViewCell else { return UITableViewCell() }
        let data = interests[indexPath.section]
        cell.configure(with: data)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return interests.count
    }

}
