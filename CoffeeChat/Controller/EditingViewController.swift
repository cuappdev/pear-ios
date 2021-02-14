//
//  EditingViewController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 3/11/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

// MARK: - TableView Sections
enum ItemType {
    case interest(Interest)
    case group(Group)

    func getName() -> String {
        switch self {
        case .interest(let interest):
            return interest.name
        case .group(let group):
            return group.name
        }
    }
}

enum SectionType: CaseIterable {
    case yours
    case more
}

/// Section represents each section of the view
class Section {
    let type: SectionType
    var items: [ItemType]

    // filteredItems is always the result of items sorted by matching its name with filteredString
    var filteredItems: [ItemType] { get { filteredItemsInternal } }
    private var filteredItemsInternal: [ItemType]
    var filterString: String?

    // How section sorts its content
    private let sortStrategy: ((ItemType, ItemType) -> Bool) = { $0.getName() < $1.getName() }

    init(type: SectionType, items: [ItemType]) {
        self.type = type
        self.items = items.sorted(by: sortStrategy)
        self.filteredItemsInternal = items
    }

    func addItem(_ item: ItemType) {
        items.append(item)
        items.sort(by: sortStrategy)
        refilter()
    }

    func removeItem(named name: String) -> ItemType? {
        if let loc = items.firstIndex(where: { $0.getName() == name }) {
            let removed = items.remove(at: loc)
            items.sort(by: sortStrategy)
            refilter()
            return removed
        }
        return nil
    }

    func refilter() {
        if let str = filterString {
            filteredItemsInternal = items.filter { $0.getName().localizedCaseInsensitiveContains(str) }
        } else {
            filteredItemsInternal = items
        }
    }

}

// MARK: - UIViewController
class EditingViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let saveBarButtonItem = UIBarButtonItem()
    private let tableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Display Settings
    private var isShowingGroups = true
    private var isCollapsed = true
    private var numRowsShownWhenCollapsed = 3

    private var sections: [Section] = []
    private let user: User

    // moreSection refers to the categories the user has not selected.
    // Selecting something in this section would add it to `yourSection`.
    private var moreSection: Section? {
        get {
            if let loc = sections.firstIndex(where: { $0.type == .more }) {
                return sections[loc]
            } else {
                return nil
            }
        }
    }
    private var moreSectionSize: Int {
        get { moreSection?.filteredItems.count ?? 0 }
    }

    // yourSection refers to the categories the user has already selected or is saved in UserDefaults.
    // Deselecting a cell here would move it to moreSection.
    private var yourSection: Section? {
        get {
            if let loc = sections.firstIndex(where: { $0.type == .yours }) {
                return sections[loc]
            } else {
                return nil
            }
        }
    }

    private var yourSectionSize: Int {
        get { yourSection?.filteredItems.count ?? 0 }
    }

    // MARK: - Initialization
    init(user: User, isShowingGroups: Bool) {
        self.user = user
        self.isShowingGroups = isShowingGroups
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit \(isShowingGroups ? "Groups" : "Interests")"
        view.backgroundColor = .backgroundLightGreen

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.backgroundColor = .none
        tableView.allowsMultipleSelection = true
        tableView.bounces = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(39)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        setupSections()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupSections() {
        if isShowingGroups {
//            setupSectionsFomGroups()
            let organizationStrings = Constants.Options.organizations.map(\.name)
            let yoursAndMore = removeDuplicates(yourStrings: user.groups, moreStrings: organizationStrings)
            let stringToGroup = { ItemType.group(Constants.Options.organizationsMap[$0]!) }
            sections = [
               Section(type: .yours, items: yoursAndMore.your.compactMap(stringToGroup)),
               Section(type: .more, items: yoursAndMore.more.compactMap(stringToGroup))
            ]
        } else {
//            setupSectionsFromInterests()
            let interestsStrings = Constants.Options.interests.map(\.name)
            let yoursAndMore = removeDuplicates(yourStrings: user.interests, moreStrings: interestsStrings)
            let stringToInterest = { ItemType.interest(Constants.Options.interestsMap[$0]!) }
            sections = [
                Section(type: .yours, items: yoursAndMore.your.compactMap(stringToInterest)),
                Section(type: .more, items: yoursAndMore.more.compactMap(stringToInterest))
            ]
        }
        tableView.reloadData()
    }

    private func setupSectionsFomGroups() {
        NetworkManager.shared.getAllGroups().observe { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .value(let result):
                guard result.success else {
                    print("Response not successful when getting groups for user")
                    return
                }

                let yoursAndMore = self.removeDuplicates(yourStrings: self.user.groups, moreStrings: result.data)
                self.sections = [
                    Section(type: .yours, items: yoursAndMore.your.map { .group(Group(name: $0, imageName: "")) }),
                    Section(type: .more, items: yoursAndMore.more.map { .group(Group(name: $0, imageName: "")) })
                ]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .error(let error):
                print("Error when getting groups for user: \(error)")
            }
        }
    }

    private func setupSectionsFromInterests() {
        NetworkManager.shared.getAllInterests().observe { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .value(let result):
                guard result.success else {
                    print("Network error: could not get interests.")
                    return
                }
                let yoursAndMore = self.removeDuplicates(yourStrings: self.user.interests, moreStrings: result.data)
                let stringToInterest = { ItemType.interest(Interest(name: $0, categories: nil, imageName: "")) }
                self.sections = [
                    Section(type: .yours, items: yoursAndMore.your.compactMap(stringToInterest)),
                    Section(type: .more, items: yoursAndMore.more.compactMap(stringToInterest))
                ]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .error:
                print("Network error: could not get interests.")
            }
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(.medium, size: 24)
        ]

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 10, height: 20))
        }
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        saveBarButtonItem.title = "Save"
        saveBarButtonItem.tintColor = .darkGreen
        saveBarButtonItem.target = self
        saveBarButtonItem.action = #selector(savePressed)
        saveBarButtonItem.setTitleTextAttributes([
            .font: UIFont.getFont(.medium, size: 20)
        ], for: .normal)
        saveBarButtonItem.setTitleTextAttributes([
            .font: UIFont.getFont(.medium, size: 20)
        ], for: .disabled)
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    // MARK: - Button Action
    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func savePressed() {
        guard let yourSection = yourSection else {
            navigationController?.popViewController(animated: true)
            return
        }
        var interests: [Interest] = []
        var groups: [Group] = []

        for item in yourSection.items {
            switch item {
            case .interest(let interest):
                interests.append(interest)
            case .group(let group):
                groups.append(group)
            }
        }

        if isShowingGroups {
            NetworkManager.shared.updateUserGroups(groups: groups.map(\.name)).observe { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        if response.success {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                        }
                    case .error:
                        self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                    }
                }
            }
        } else {
            NetworkManager.shared.updateUserInterests(interests: interests.map(\.name)).observe { result in
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        if response.success {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                        }
                    case .error:
                        self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                    }
                }
            }
        }
    }

    /// Remove duplicated entries in `yourStrings` and `moreStrings`. If a duplicate exists in both `yourStrings`
    /// and `moreStrings`, duplicates are removed from `moreStrings`, so only 1 exists in `yourStrings`
    private func removeDuplicates(yourStrings: [String], moreStrings: [String]) -> (your: [String], more: [String]) {
        var set = Set<String>()

        yourStrings.forEach { set.insert($0) }
        let yourList = Array(set).sorted()

        var moreList: [String] = []
        for string in moreStrings {
            if set.insert(string).inserted {
                moreList.append(string)
            }
        }
        moreList.sort()

        return (your: yourList, more: moreList)
    }

    /// Moves an interest or group with name identifier from a source section to the target section
    private func moveData(named name: String, from source: Section, to target: Section) {
        let removed = source.removeItem(named: name)
        if let removed = removed { target.addItem(removed) }
    }

}

// MARK: - UITableViewDelegate
extension EditingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.filteredItems[indexPath.row]

        let itemName: String
        guard let yourSection = yourSection else { return }
        guard let moreSection = moreSection else { return }

        switch item {
        case .interest(let interest):
            itemName = interest.name
        case .group(let group):
            itemName = group.name
        }

        switch section.type {
        case .yours:
            moveData(named: itemName, from: yourSection, to: moreSection)
        case .more:
            moveData(named: itemName, from: moreSection, to: yourSection)
        }

        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource
extension EditingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        switch sections[sectionIndex].type {
        case .yours:
            return isCollapsed && yourSectionSize > numRowsShownWhenCollapsed
                ? numRowsShownWhenCollapsed
                : yourSectionSize

        case .more:
            return moreSectionSize
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let itemType = section.filteredItems[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: OnboardingTableViewCell.reuseIdentifier,
                            for: indexPath
                        ) as? OnboardingTableViewCell else {
            return UITableViewCell()
        }

        switch itemType {
        case .interest(let interest):
            cell.configure(with: interest)
        case .group(let group):
            cell.configure(with: group)
        }

        cell.changeColor(selected: section.type == .yours)
        cell.shouldSelectionChangeAppearence = false

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EditHeaderView()
        let section = sections[section]
        let labelTitle: String
        let labelSubtext: String

        switch section.type {
        case .yours:
            labelTitle = isShowingGroups ? "Your Groups" : "Your Interests"
            if yourSectionSize == 0 {
                labelSubtext = isShowingGroups
                    ? "Select a group so we can better help you find a pair!"
                    : "Select at least one interest so we can better help you find a pair!"
                saveBarButtonItem.isEnabled = false
            } else {
                labelSubtext = "tap to deselect"
                saveBarButtonItem.isEnabled = true
            }
            headerView.configure(with: labelTitle, info: labelSubtext, shouldIncludeSearchBar: false)

        case .more:
            labelTitle = isShowingGroups ? "More Groups" : "More Interests"
            labelSubtext = isShowingGroups ? "tap or search to add" : "tap to add"
            headerView.configure(with: labelTitle, info: labelSubtext, shouldIncludeSearchBar: isShowingGroups)

            if isShowingGroups {
                headerView.searchDelegate = { searchText in
                    self.moreSection?.filterString = searchText
                    self.moreSection?.refilter()
                    self.tableView.reloadData()
                }
            }
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && yourSectionSize > numRowsShownWhenCollapsed {
            let footerView = EditFooterView(isShowingGroups: isShowingGroups)
            footerView.sectionIsCollapsed = isCollapsed
            footerView.updateViewState()
            footerView.delegate = {
                self.isCollapsed = $0
                self.tableView.reloadData()
                self.tableView.setNeedsLayout()
            }

            return footerView
        } else {
            return UIView()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        isShowingGroups && section == 1 ? 128 : 86
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        yourSectionSize > numRowsShownWhenCollapsed && section == 0 ? 64 : 0
    }

}

// MARK: - UITableView Header
private class EditHeaderView: UIView, UISearchBarDelegate {

    private let stackView = UIStackView()
    private let label = UILabel()
    private var searchBar: UISearchBar?

    /// Callback when search text is changed
    var searchDelegate: ((String?) -> Void)?

    func configure(with title: String, info: String, shouldIncludeSearchBar: Bool) {
        setupText(title: title, info: info)
        setupViews(shouldIncludeSearchBar: shouldIncludeSearchBar)
        setupConstraints()
    }

    private func setupText(title: String, info: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0.0
        style.alignment = .center
        let primaryAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._20CircularStdMedium as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.black
        ]
        let secondaryAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._12CircularStdBook as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.greenGray
        ]

        let title = NSMutableAttributedString(string: "\(title)\n", attributes: primaryAttributes)
        let subtitle = NSMutableAttributedString(string: info, attributes: secondaryAttributes)

        let fullTitle = NSMutableAttributedString()
        fullTitle.append(title)
        fullTitle.append(subtitle)

        label.attributedText = fullTitle
    }

    private func setupViews(shouldIncludeSearchBar: Bool) {
        label.numberOfLines = 0
        if shouldIncludeSearchBar {
            setupSearchbar()
        }
        setupStack()
    }

    private func setupSearchbar() {
        let searchBar = UISearchBar()

        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.clipsToBounds = false

        searchBar.backgroundColor = .backgroundWhite
        searchBar.backgroundImage = UIImage()

        searchBar.searchTextField.backgroundColor = .backgroundWhite
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = ._20CircularStdBook
        searchBar.searchTextField.clearButtonMode = .never

        searchBar.layer.cornerRadius = 8
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchBar.layer.shadowOpacity = 0.1
        searchBar.layer.shadowRadius = 2

        self.searchBar = searchBar
    }

    private func setupStack() {
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillProportionally

        stackView.insertArrangedSubview(label, at: 0)
        if let searchBar = searchBar {
            stackView.insertArrangedSubview(searchBar, at: 1)
        }

        addSubview(stackView)
    }

    private func setupConstraints() {
        let stackPadding = 12

        label.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        searchBar?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().inset(stackPadding)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDelegate?(searchText == "" ? nil : searchText)
    }

}

// MARK: UITableViewFooter
private class EditFooterView: UIButton {

    private let isShowingGroups: Bool
    var sectionIsCollapsed = false

    private let arrowView = UIImageView()
    private let label = UILabel()
    private let stackView = UIStackView()

    var delegate: ((Bool) -> Void)?

    init(isShowingGroups: Bool) {
        self.isShowingGroups = isShowingGroups
        super.init(frame: .zero)

        setupViews()
        setupConstraints()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        label.font = UIFont._16CircularStdMedium
        label.textColor = .greenGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = false

        arrowView.image = UIImage(named: "rightArrow")
        arrowView.isUserInteractionEnabled = false
        arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))

        stackView.isUserInteractionEnabled = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.insertArrangedSubview(arrowView, at: 0)
        stackView.insertArrangedSubview(label, at: 1)
        addSubview(stackView)

        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
    }

    private func setupConstraints() {
        arrowView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 9, height: 18))
        }

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(44)
        }
    }

    func updateViewState() {
        if sectionIsCollapsed {
            label.text = "View your other \(isShowingGroups ? "groups" : "interests")"
            arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        } else {
            label.text = "View fewer \(isShowingGroups ? "groups" : "interests")"
            arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }

        delegate?(sectionIsCollapsed)
    }

    @objc func buttonPressed() {
        sectionIsCollapsed.toggle()
        updateViewState()
    }

    func configure() {
        label.text = isShowingGroups ? "view your other groups" : "view your other interests"
    }

}

extension EditingViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
            navigationController?.popViewController(animated: true)
        }
        return false
    }
    
}
