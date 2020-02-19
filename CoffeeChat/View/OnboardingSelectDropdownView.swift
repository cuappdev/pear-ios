//
//  OnboardingDropdownView.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/15/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class OnboardingSelectDropdownView: UIView {

    // MARK: - Private View Vars
    private let dropdownButton = UIButton()
    private let tableView = OnboardingSelectTableView()

    // MARK: - Private Data Vars
    private weak var delegate: OnboardingSearchViewDelegate?
    private var placeholder: String!
    private let reuseIdentifier = "OnboardingDropdownCell"
    private var tableData: [String]!
    private var textTemplate: String = ""
    private var shouldShowFields: Bool = false

    // MARK: - Private Constants
    private let fieldsCornerRadius: CGFloat = 8
    
    init(delegate: OnboardingSearchViewDelegate, placeholder: String, tableData: [String], textTemplate: String) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.placeholder = placeholder
        self.tableData = tableData
        self.textTemplate = textTemplate
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
                    NSAttributedString.Key.font: UIFont._20CircularStdBook]), // LUCY - Revisit
            for: .normal
        )
        dropdownButton.layer.cornerRadius = fieldsCornerRadius
        dropdownButton.contentHorizontalAlignment = .left
        dropdownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0) // Shift placeholder into place.
        dropdownButton.layer.shadowColor = UIColor.black.cgColor
        dropdownButton.layer.shadowOffset = CGSize(width: 0.0 , height: 2.0)
        dropdownButton.layer.shadowOpacity = 0.15
        dropdownButton.layer.shadowRadius = 2
        dropdownButton.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        addSubview(dropdownButton)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true // Initially hide the field data tableview.
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.bounces = false
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = .darkGray
        tableView.layer.cornerRadius = fieldsCornerRadius
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

    /// Toggles the view to show or hide dropdown table view.
    @objc func toggleDropDown() {
        shouldShowFields.toggle()
        tableView.isHidden = !shouldShowFields
        if shouldShowFields {
            // Show dropdown table view when user taps on bar.
            let height = tableView.contentSize.height
            delegate?.bringSearchViewToFront(searchView: self, height: height, isSelect: true)
        } else {
            // Dismiss table view if user taps on bar again.
            delegate?.sendSearchViewToBack(searchView: self)
        }
    }

    /// Hide search results table view, intended to be called by parent view controller.
    func collapseTableView() {
        tableView.isHidden = true
    }
}

extension OnboardingSelectDropdownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            as? OnboardingDropdownTableViewCell else { return UITableViewCell() }
        cell.configure(with: tableData[indexPath.row])
        return cell
    }

    /// Updates dropdown text when a cell is selected in the table view and hides the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropdownButton.setAttributedTitle(
            NSAttributedString(
                string: "\(textTemplate) \(tableData[indexPath.row])", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.textBlack,
                    NSAttributedString.Key.font: UIFont._20CircularStdBook]), // LUCY - Revisit
            for: .normal)
        tableView.isHidden = true
        delegate?.updateSelectedFields(tag: self.tag, isSelected: true)
        delegate?.sendSearchViewToBack(searchView: self)
    }
}
