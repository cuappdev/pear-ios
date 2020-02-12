//
//  GroupsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/9/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class GroupsViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?

    // MARK: - Private View Vars
    private let searchBar = UISearchBar()
    private let backButton = UIButton()
    private let clubLabel = UILabel()
    private let greetingLabel = UILabel()
    private let nextButton = UIButton()
    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Gradients
    // Fade out affects on the top and bottom of the tableView
    private let bottomFadeView = UIView()
    private let topFadeView = UIView()

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

        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
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

        clubLabel.text = "What clubs are you in?"
        clubLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(clubLabel)

        nextButton.setTitle("Get started!", for: .normal)
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

    private func setupConstraints() {

        let backBottomPadding: CGFloat = 49
        let backButtonSize = CGSize(width: 62, height: 20)
        let nextButtonSize = CGSize(width: 225, height: 54)
        let nextBottomPadding: CGFloat = 21
        let titleHeight: CGFloat = 30
        let titleSpacing: CGFloat = 100

        let tableViewTopPadding: CGFloat = 24
        let tableViewSize = CGSize(width: 295, height: 365)

        let topFadeHeight: CGFloat = 10
        let fadeHeight: CGFloat = 26

        let searchSize = CGSize(width: 295, height: 42)
        let searchTopPadding: CGFloat = 50

        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(clubLabel.snp.bottom).offset(searchTopPadding)
            make.size.equalTo(searchSize)
        }

        clubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleSpacing)
        }

        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(tableViewSize)
            make.top.equalTo(searchBar.snp.bottom).offset(tableViewTopPadding)
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
            make.bottom.equalTo(backButton.snp.top).offset(-nextBottomPadding)
        }

        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(backBottomPadding)
        }
    }

    @objc func nextButtonPressed() {
        print("Next button pressed.")
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 1)
    }

}


// MARK: TableViewDelegate
extension GroupsViewController: UITableViewDelegate {

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
//        selectedInterests.append(interests[indexPath.section])
//        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        selectedInterests.removeAll { $0.name == interests[indexPath.section].name}
//        updateNext()
    }

}

// MARK: TableViewDataSource
extension GroupsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier:
//            OnboardingTableViewCell.reuseIdentifier, for: indexPath) as?
//        OnboardingTableViewCell else { return UITableViewCell() }
//        let data = interests[indexPath.section]
//        cell.configure(with: data)
//        return cell
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
//        return interests.count
        return 0
    }

}

extension GroupsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // ...
    }
}
