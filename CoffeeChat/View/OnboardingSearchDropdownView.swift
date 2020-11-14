//
//  OnboardingSearchDropdownView.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/13/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

protocol OnboardingDropdownViewDelegate: class {
    func bringDropdownViewToFront(dropdownView: UIView, height: CGFloat, isSelect: Bool)
    func sendDropdownViewToBack(dropdownView: UIView)
    func updateDropdownViewHeight(dropdownView: UIView, height: CGFloat)
    func updateSelectedFields(tag: Int, isSelected: Bool, valueSelected: String)
}

/// Custom onboarding dropdown tableview that resizes based on content
class OnboardingSelectTableView: UITableView {
    let maxHeight: CGFloat = 230.0

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}

class OnboardingSearchDropdownView: UIView {

    // MARK: - Private View Vars
    private let searchBar = UISearchBar()
    private let tableView = OnboardingSelectTableView()

    // MARK: - Private Data Vars
    private weak var delegate: OnboardingDropdownViewDelegate?
    private var placeholder: String
    private let reuseIdentifier = "OnboardingDropdownCell"
    private var resultsTableData: [String] = []
    var tableData: [String]

    // MARK: - Private Constants
    private let fieldsCornerRadius: CGFloat = 8

    init(delegate: OnboardingDropdownViewDelegate, placeholder: String, tableData: [String]) {
        self.delegate = delegate
        self.placeholder = placeholder
        self.tableData = tableData
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        searchBar.delegate = self
        searchBar.backgroundColor = .backgroundWhite
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = placeholder
        searchBar.setImage(UIImage(), for: .search, state: .normal) // Remove search icon from search bar.
        searchBar.searchTextField.backgroundColor = .backgroundWhite
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = ._20CircularStdBook
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.layer.cornerRadius = fieldsCornerRadius
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchBar.layer.shadowOpacity = 0.15
        searchBar.layer.shadowRadius = 2
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: -6, vertical: 0)
        searchBar.showsCancelButton = false
        addSubview(searchBar)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true // Initially hide the field data tableview.
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = .darkGray
        tableView.layer.cornerRadius = fieldsCornerRadius
        tableView.bounces = false
        tableView.register(OnboardingDropdownTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        addSubview(tableView)
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(49)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(-10)
        }
    }

    /// Hide search results table view, intended to be called by parent view controller.
    func hideTableView() {
        tableView.isHidden = true
    }

    /// Set text of field if value already exists.
    func setSelectValue(value: String) {
        searchBar.text = value
    }
}

extension OnboardingSearchDropdownView: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsTableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            as? OnboardingDropdownTableViewCell else { return UITableViewCell() }
        cell.configure(with: resultsTableData[indexPath.row])
        return cell
    }

    /// Updates searchbar text when a cell is selected in the table view and hides the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedText = resultsTableData[indexPath.row]
        searchBar.text = selectedText
        tableView.isHidden = true
        delegate?.updateSelectedFields(tag: self.tag, isSelected: true, valueSelected: selectedText)
        delegate?.sendDropdownViewToBack(dropdownView: self)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let height = tableView.contentSize.height
        delegate?.bringDropdownViewToFront(dropdownView: self, height: height, isSelect: false)
    }

    /// Expands and updates search results table view when text is changed in the search bar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.isHidden = false
        resultsTableData = searchText.isEmpty ? [] : tableData.filter { $0.localizedCaseInsensitiveContains(searchText) }
        delegate?.updateSelectedFields(tag: self.tag, isSelected: false, valueSelected: "") // Reset fieldSelected to false.
        tableView.reloadData()
        // Recalculate height of table view and update view height in parent view.
        let newHeight = tableView.contentSize.height
        delegate?.updateDropdownViewHeight(dropdownView: self, height: newHeight)
    }
}
