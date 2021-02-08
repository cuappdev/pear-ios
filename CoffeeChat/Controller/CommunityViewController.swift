//
//  CommunityViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    // MARK: - Private View Vars
    private let communityTableView = UITableView()
    private let searchBar = UISearchBar()

    // MARK: - Private Data Vars
    private var users: [CommunityUser] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen

        searchBar.delegate = self
        searchBar.backgroundColor = .backgroundWhite
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = .backgroundWhite
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = ._16CircularStdBook
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.layer.cornerRadius = 8
        searchBar.showsCancelButton = false
        searchBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowRadius = 4
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(searchBar)

        communityTableView.delegate = self
        communityTableView.dataSource = self
        communityTableView.isScrollEnabled = true
        communityTableView.separatorStyle = .none
        communityTableView.backgroundColor = .clear
        communityTableView.rowHeight = UITableView.automaticDimension
        communityTableView.estimatedRowHeight = 140
        communityTableView.sizeToFit()
        communityTableView.register(CommunityUserTableViewCell.self, forCellReuseIdentifier: CommunityUserTableViewCell.reuseIdentifier)
        view.addSubview(communityTableView)

        setupConstraints()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.communityTableView.reloadData()
    }

    private func getUsers() {
        NetworkManager.shared.getUsers().observe { response in
            switch response {
            case .value(let value):
                guard value.success else { return }
                DispatchQueue.main.async {
                    self.users = value.data
                    self.communityTableView.reloadData()
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }

        communityTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUsers()
        super.viewDidAppear(animated)
    }
}

extension CommunityViewController: UITableViewDelegate {}

extension CommunityViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityUserTableViewCell.reuseIdentifier, for: indexPath) as? CommunityUserTableViewCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }

}

// MARK: - SearchBarDelegate
extension CommunityViewController: UISearchBarDelegate {

    private func searchUsers(query: String) {
        NetworkManager.shared.searchUsers(query: query).observe { response in
            switch response {
            case .value(let value):
                guard value.success else { return }
                DispatchQueue.main.async {
                    self.users = value.data
                    self.communityTableView.reloadData()
                }
            case .error(let error):
                print(error)
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            getUsers()
        } else {
            searchUsers(query: searchText)
        }
    }

}
