//
//  TalkingPointsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class TalkingPointsViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?
    // TODO: change when networking with backend
    private var displayedTalkingPoints: [SimpleOnboardingCell] = []
    private let interests = Constants.Options.interests
    private var talkingPoints: [SimpleOnboardingCell] = []
    private var selectedInterestsGroups: [SimpleOnboardingCell] = []

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let nextButton = UIButton()
    private let searchBar = UISearchBar()
    private let skipButton = UIButton()
    private let fadeTableView = FadeWrapperView(
        UITableView(frame: .zero, style: .plain),
        fadeColor: .backgroundLightGreen
    )

    init(delegate: OnboardingPageDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        searchBar.delegate = self
        searchBar.backgroundColor = .backgroundWhite
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Search interests and groups"
        searchBar.searchTextField.backgroundColor = .backgroundWhite
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = ._16CircularStdBook
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.layer.cornerRadius = 8
        searchBar.showsCancelButton = false
        view.addSubview(searchBar)

        fadeTableView.view.allowsMultipleSelection = true
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
        fadeTableView.view.dataSource = self
        fadeTableView.view.keyboardDismissMode = .onDrag
        fadeTableView.view.delegate = self
        fadeTableView.view.register(SimpleOnboardingTableViewCell.self, forCellReuseIdentifier: SimpleOnboardingTableViewCell.reuseIdentifier)
        fadeTableView.view.separatorStyle = .none
        view.addSubview(fadeTableView)

        titleLabel.text = "What do you most want\nto talk about?"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        nextButton.setTitle("Almost there", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = 26
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        skipButton.titleLabel?.font = ._16CircularStdMedium
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.greenGray, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        view.addSubview(skipButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllTalkingPoints()
        getUserTalkingPoints()
    }
    
    private func getUserTalkingPoints() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getUser(netId: netId).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        let userTalkingPoints = response.data.talkingPoints.map {
                            return SimpleOnboardingCell(name: $0, subtitle: nil)
                        }
                        self.selectedInterestsGroups = userTalkingPoints
                        self.fadeTableView.view.reloadData()
                        self.updateNext()
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func getAllTalkingPoints() {
        NetworkManager.shared.getAllGroups().observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        let groups = response.data
                        self.talkingPoints = groups.map {
                            return SimpleOnboardingCell(name: $0, subtitle: nil)
                        }
                        let onboardingInterests = self.interests.map {
                            // TODO: Fix interest model in backend before using to populate screen
                            return SimpleOnboardingCell(name: $0.name, subtitle: $0.categories?.joined(separator: ", ") ?? nil)
                        }
                        self.talkingPoints.append(contentsOf: onboardingInterests)
                        self.talkingPoints.sort(by: { $0.name < $1.name })
                        self.displayedTalkingPoints = self.talkingPoints
                        self.fadeTableView.view.reloadData()
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
    }

    private func setupConstraints() {
        let backSize = CGSize(width: 86, height: 20)
        let searchBarTopPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 40)

        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(6)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }

        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(searchBarTopPadding)
            make.size.equalTo(CGSize(width: 295, height: 40))
        }

        fadeTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
            make.top.equalTo(searchBar.snp.bottom).offset(17)
            make.bottom.equalTo(nextButton.snp.top).offset(-57)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }

        skipButton.snp.makeConstraints { make in
            make.size.equalTo(backSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.skipBottomPadding)
        }

    }

    /// Filters table view results based on text typed in search
    private func filterTableView(searchText: String) {
        displayedTalkingPoints = searchText.isEmpty
            ? talkingPoints
            : talkingPoints.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        fadeTableView.view.reloadData()
    }

    // MARK: - Next and Previous Buttons
    /// Updates the enabled state of next button based on the state of selectedInterestsGroups.
    private func updateNext() {
        nextButton.isEnabled = selectedInterestsGroups.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
        skipButton.isEnabled = selectedInterestsGroups.count == 0
        let skipButtonColor: UIColor = skipButton.isEnabled ? .greenGray : .inactiveGreen
        skipButton.setTitleColor(skipButtonColor, for: .normal)
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 3)
    }

    @objc func nextButtonPressed() {
        let talkingPoints = selectedInterestsGroups.map { $0.name }
        NetworkManager.shared.updateUserTalkingPoints(talkingPoints: talkingPoints).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    print("Update talking points success response \(response)")
                    if response.success {
                        self.delegate?.nextPage(index: 5)
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
    }

    @objc func skipButtonPressed() {
        delegate?.nextPage(index: 5)
    }

}

// MARK: - TableViewDelegate
extension TalkingPointsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return talkingPoints[indexPath.row].subtitle != nil ? 61 : 54
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedTalkingPoints.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterestsGroups.append(displayedTalkingPoints[indexPath.row])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedInterestsGroups.removeAll { $0.name == displayedTalkingPoints[indexPath.row].name}
        updateNext()
    }

}

// MARK: - TableViewDataSource
extension TalkingPointsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleOnboardingTableViewCell.reuseIdentifier,
                                                       for: indexPath) as?
                SimpleOnboardingTableViewCell else { return UITableViewCell() }
        let data = displayedTalkingPoints[indexPath.row]
        cell.configure(with: data)
        // Keep previous selected cell when reloading tableView
        if selectedInterestsGroups.contains(where: { $0.name == data.name }) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }

}

// MARK: - SearchBarDelegate
extension TalkingPointsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(searchText: searchText)
    }

}
