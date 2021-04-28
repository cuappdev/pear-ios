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
    private let fadeCommunityTableView = FadeWrapperView(
        UITableView(frame: .zero, style: .plain),
        fadeColor: .backgroundLightGreen)
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
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.layer.cornerRadius = 8
        searchBar.showsCancelButton = false
        searchBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowRadius = 4
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(searchBar)

        fadeCommunityTableView.view.delegate = self
        fadeCommunityTableView.view.dataSource = self
        fadeCommunityTableView.view.isScrollEnabled = true
        fadeCommunityTableView.view.separatorStyle = .none
        fadeCommunityTableView.view.backgroundColor = .clear
        fadeCommunityTableView.view.showsVerticalScrollIndicator = false
        fadeCommunityTableView.view.rowHeight = UITableView.automaticDimension
        fadeCommunityTableView.view.estimatedRowHeight = 140
        fadeCommunityTableView.view.sizeToFit()
        fadeCommunityTableView.view.bounces = true
        fadeCommunityTableView.view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        fadeCommunityTableView.view.register(CommunityUserTableViewCell.self, forCellReuseIdentifier: CommunityUserTableViewCell.reuseIdentifier)
        view.addSubview(fadeCommunityTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        setupConstraints()
    }

    private func getUsers() {
        NetworkManager.shared.getUsers().observe { response in
            DispatchQueue.main.async {
                switch response {
                case .value(let value):
                    guard value.success else {
                        print("Network error: could not get users.")
                        return
                    }
                    self.users = value.data
                    self.fadeCommunityTableView.view.reloadData()
                case .error:
                    print("Network error: could not get users.")
                }
            }
        }
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }

        fadeCommunityTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUsers()
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        navigationController?.pushViewController(ProfileViewController(userId: user.netID), animated: true)
    }
}

// MARK: - SearchBarDelegate
extension CommunityViewController: UISearchBarDelegate {

    private func searchUsers(query: String) {
        NetworkManager.shared.searchUsers(query: query).observe { response in
            DispatchQueue.main.async {
                switch response {
                case .value(let value):
                        guard value.success else {
                            print("Network error: could not search users")
                            return
                        }
                        self.users = value.data
                        self.fadeCommunityTableView.view.reloadData()
                case .error:
                    print("Network error: could not search users")
                }
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
