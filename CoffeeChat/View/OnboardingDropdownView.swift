//
//  OnboardingDropdownView.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/15/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class OnboardingDropdownView: UIView {

    // MARK: - Private View Vars
    private let dropdownButton = UIButton()
    private let tableView = OnboardingSelectTableView()

    // MARK: - Private Data Vars
    private weak var delegate: OnboardingSearchViewDelegate?
    private var placeholder: String!
    private let reuseIdentifier = "OnboardingDropdownCell"
    private var tableData: [String]!

    private var shouldShowFields: Bool = false
    private var fieldSelected: Bool = false


    // MARK: - Private Constants
    private let fieldsCornerRadius: CGFloat = 8
    
    init(delegate: OnboardingSearchViewDelegate, placeholder: String, tableData: [String]) {
        super.init(frame: .zero)
        self.tableData = tableData
        self.placeholder = placeholder
        self.delegate = delegate
        addViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        dropdownButton.backgroundColor = .backgroundWhite
        dropdownButton.setAttributedTitle(
            NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.metaData,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)]),
            for: .normal
        )
        dropdownButton.layer.cornerRadius = fieldsCornerRadius
        dropdownButton.contentHorizontalAlignment = .left
        dropdownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        dropdownButton.layer.shadowOffset = CGSize(width: 0.0 , height: 2.0)
        dropdownButton.layer.shadowColor = UIColor.black.cgColor
        dropdownButton.layer.shadowOpacity = 0.15
        dropdownButton.layer.shadowRadius = 2
        dropdownButton.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        addSubview(dropdownButton)

        tableView.isHidden = true
        tableView.tag = 100
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
        tableView.layer.cornerRadius = fieldsCornerRadius
        tableView.bounces = false
        tableView.register(OnboardingDropdownTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        addSubview(tableView)
    }

    private func setupConstraints() {
        dropdownButton.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(49)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(dropdownButton.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(-10)
        }
    }

    @objc func toggleDropDown() {
        shouldShowFields.toggle()
        tableView.isHidden = !shouldShowFields
//        self.endEditing(true)
//        let newHeight = shouldShowFields ? tableView.contentSize.height : 0
        if shouldShowFields {
            delegate?.bringSearchViewToFront(searchView: self, height: tableView.contentSize.height, dropdown: true)
        } else {
            delegate?.sendSearchViewToBack(searchView: self)
        }
    }

    func collapseTableView() {
        tableView.isHidden = true
    }
}

extension OnboardingDropdownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! OnboardingDropdownTableViewCell
        cell.configure(with: tableData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropdownButton.setAttributedTitle(
        NSAttributedString(string: tableData[indexPath.row], attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.textBlack,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)]), for: .normal)
        fieldSelected = true
        tableView.isHidden = true
        delegate?.updateSelectedFields(fieldTag: self.tag, selected: true)
        delegate?.sendSearchViewToBack(searchView: self)
    }
}
