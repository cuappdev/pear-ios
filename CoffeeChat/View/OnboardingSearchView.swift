//
//  OnboardingSearchView.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/13/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

protocol OnboardingSearchViewDelegate: class {
    func bringSearchViewToFront(searchView: UIView)
    func sendSearchViewToBack(searchView: UIView)
}

class OnboardingSelectTableView: UITableView {

    let maxHeight: CGFloat = 213.0

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

class OnboardingSearchView: UIView {

    // MARK: - Private View Vars
    private let searchBar = UISearchBar()
    private let tableView = OnboardingSelectTableView()

    // MARK: - Private Data Vars
    private weak var delegate: OnboardingSearchViewDelegate?
    private var placeholder: String!
    private let reuseIdentifier = "OnboardingDropdownCell"
    private var searchedTableData: [String] = []
    private var tableData: [String]!

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

    func addViews() {
        searchBar.backgroundColor = .backgroundWhite
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .backgroundWhite
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray])
            textField.font = .systemFont(ofSize: 20, weight: .medium)
            textField.clearButtonMode = .never
        }
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.layer.cornerRadius = fieldsCornerRadius
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: -6, vertical: 0)
        searchBar.showsCancelButton = false
        addSubview(searchBar)

        tableView.isHidden = true
        tableView.tag = 200
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.layer.zPosition = 1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
        tableView.layer.cornerRadius = fieldsCornerRadius
        tableView.bounces = false
        tableView.register(OnboardingDropdownTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        addSubview(tableView)
    }

    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(49)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(-10)
        }
    }

    func collapseTableView() {
        tableView.isHidden = true
    }
}

extension OnboardingSearchView: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedTableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! OnboardingDropdownTableViewCell
        cell.configure(with: searchedTableData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = searchedTableData[indexPath.row]
        tableView.isHidden = true
        delegate?.sendSearchViewToBack(searchView: self)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        delegate?.sendSearchViewToBack(searchView: self)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedTableData = searchText.isEmpty ? [] : tableData.filter { $0.localizedCaseInsensitiveContains(searchText) }
        delegate?.bringSearchViewToFront(searchView: self)
        tableView.isHidden = false
        tableView.reloadData()
    }
}
