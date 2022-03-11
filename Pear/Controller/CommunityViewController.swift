//
//  CommunityViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import FirebaseAnalytics
import UIKit

class CommunityViewController: UIViewController {

    // MARK: - Private View Vars
    private let fadeCommunityTableView = FadeWrapperView(
        UITableView(frame: .zero, style: .plain),
        fadeColor: .backgroundLightGreen)
    private let searchRefreshControl = UIRefreshControl()
    private let searchBar = UISearchBar()
    private let spinner = UIActivityIndicatorView(style: .medium)
    // MARK: - Private Data Vars
    private var users: [CommunityUser] = []
    private let currentUser: UserV2
    
    init(user: UserV2) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen

        searchBar.delegate = self
        searchBar.backgroundColor = .backgroundWhite
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = false
        searchBar.searchTextField.backgroundColor = .backgroundWhite
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = ._16CircularStdBook
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.layer.cornerRadius = 8
        searchBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowRadius = 4
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(searchBar)
        
        searchRefreshControl.addTarget(self, action: #selector(refreshSearches), for: .valueChanged)
        
        fadeCommunityTableView.view.backgroundView = searchRefreshControl
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
        fadeCommunityTableView.view.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 30, right: 0)
        fadeCommunityTableView.view.register(CommunityUserTableViewCell.self, forCellReuseIdentifier: CommunityUserTableViewCell.reuseIdentifier)
        view.addSubview(fadeCommunityTableView)

        spinner.startAnimating()
        view.addSubview(spinner)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        setupConstraints()
    }

    private func getAllUsers() {
        NetworkManager.getAllUsers { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let allUsers):
                DispatchQueue.main.async {
                    self.users = allUsers
                    self.spinner.stopAnimating()
                    self.searchRefreshControl.endRefreshing()
                    self.fadeCommunityTableView.view.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
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
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.top.centerX.equalTo(fadeCommunityTableView)
        }
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    @objc private func refreshSearches() {
        getUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUsers()
        Analytics.logEvent(Constants.Analytics.openedViewController, parameters: ["name" : Constants.Analytics.TrackedVCs.community])
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
        let otherUser = users[indexPath.row]
        navigationController?.pushViewController(ProfileViewController(user: currentUser, viewType: .otherUser,  otherUserId: otherUser.id), animated: true)
    }
}

// MARK: - SearchBarDelegate
extension CommunityViewController: UISearchBarDelegate {
    
    private func getUsers() {
        if let searchText = searchBar.text {
            searchUsers(query: searchText)
        } else {
            getAllUsers()
        }
    }

    private func searchUsers(query: String) {
        NetworkManager.getSearchedUsers(searchText: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let searchedUsers):
                DispatchQueue.main.async {
                    self.users = searchedUsers
                    self.spinner.stopAnimating()
                    self.searchRefreshControl.endRefreshing()
                    self.fadeCommunityTableView.view.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getUsers()
    }
}
