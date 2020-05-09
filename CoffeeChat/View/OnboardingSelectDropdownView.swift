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
    private weak var delegate: OnboardingDropdownViewDelegate?
    private var placeholder: String
    private let reuseIdentifier = "OnboardingDropdownCell"
    private var tableData: [String]
    private var textTemplate: String = ""
    private var shouldShowFields: Bool = true
    var isFilled: Bool = false

    // MARK: - Private Constants
    private let fieldsCornerRadius: CGFloat = 8
    
    init(delegate: OnboardingDropdownViewDelegate, placeholder: String, tableData: [String], textTemplate: String) {
        self.delegate = delegate
        self.placeholder = placeholder
        self.tableData = tableData
        self.textTemplate = textTemplate
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        dropdownButton.backgroundColor = .backgroundWhite
        dropdownButton.setTitle(placeholder, for: .normal)
        dropdownButton.setTitleColor(.metaData, for: .normal)
        dropdownButton.titleLabel?.font = ._20CircularStdBook
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
        if shouldShowFields {
            // Show dropdown table view when user taps on bar.
            tableView.isHidden = false
            let height = tableView.contentSize.height
            delegate?.bringDropdownViewToFront(dropdownView: self, height: height, isSelect: true)
            shouldShowFields = false
        } else {
            // Dismiss table view if user taps on bar again.
            tableView.isHidden = true
            delegate?.sendDropdownViewToBack(dropdownView: self)
            shouldShowFields = true
        }
    }

    /// Hide search results table view, intended to be called by parent view controller.
    func hideTableView() {
        tableView.isHidden = true
        shouldShowFields = true
    }

    /// Set text of field if value already exists
    func setSelectValue(value: String) {
        dropdownButton.setTitle("\(textTemplate) \(value)", for: .normal)
        dropdownButton.setTitleColor(.textBlack, for: .normal)
    }
}

extension OnboardingSelectDropdownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

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
        let selectedText = tableData[indexPath.row]
        dropdownButton.setTitle("\(textTemplate) \(selectedText)", for: .normal)
        dropdownButton.setTitleColor(.textBlack, for: .normal)
        hideTableView()
        delegate?.updateSelectedFields(tag: self.tag, isSelected: true, valueSelected: selectedText)
        delegate?.sendDropdownViewToBack(dropdownView: self)
    }
}
