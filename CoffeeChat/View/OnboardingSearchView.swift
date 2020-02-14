//
//  OnboardingSearchView.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/13/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

protocol OnboardingSearchViewDelegate: class {
    func bringSearchViewToFront(searchView: OnboardingSearchView)
    func sendSearchViewToBack(searchView: OnboardingSearchView)
}

class OnboardingSearchTableView: UITableView {

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

    private let searchBar = UISearchBar()
    private let tableView = OnboardingSearchTableView()
    private var tableData: [String] = [] // lucy
    private var reuseIdentifier: String! // lucy
    private var placeholder: String!
    private weak var delegate: OnboardingSearchViewDelegate?
    private var searchedTableData: [String] = []

    // MARK: - Private Constants
    private let fieldsCornerRadius: CGFloat = 8

    init(tableData: [String], reuseIdentifier: String, placeholder: String, delegate: OnboardingSearchViewDelegate) {
        super.init(frame: .zero)

        self.tableData = tableData
        self.reuseIdentifier = reuseIdentifier
        self.placeholder = placeholder
        self.delegate = delegate

        addViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addViews() {
        searchBar.backgroundColor = .backgroundLightGray
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .backgroundLightGray
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray])
            textField.font = .systemFont(ofSize: 20, weight: .medium)
            textField.clearButtonMode = .never
        }
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.layer.cornerRadius = fieldsCornerRadius
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: -6, vertical: 0)
        searchBar.showsCancelButton = false
        addSubview(searchBar)

        tableView.isHidden = true // LUCY - come back to this
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
//        tableView.maxHeight = 200
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.layer.zPosition = 1
//        tableView.estimatedRowHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
        tableView.layer.cornerRadius = fieldsCornerRadius
        tableView.bounces = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
//            make.height.equalTo(213)
        }
    }
}

extension OnboardingSearchView: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedTableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = searchedTableData[indexPath.row]
        cell.backgroundColor = .backgroundDarkGray
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.textLabel?.textColor = .black
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = searchedTableData[indexPath.row]
        print(indexPath.row)
        print(searchedTableData[indexPath.row])
        tableView.isHidden = true
        delegate?.sendSearchViewToBack(searchView: self)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        delegate?.sendSearchViewToBack(searchView: self)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.bringSearchViewToFront(searchView: self)
        tableView.isHidden = false
        searchedTableData = searchText.isEmpty ? tableData : tableData.filter { $0.localizedCaseInsensitiveContains(searchText)
        }
        tableView.reloadData()
        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
    }


}
