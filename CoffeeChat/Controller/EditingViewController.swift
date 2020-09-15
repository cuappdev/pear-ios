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

    // filteredItems is always the result ofitems sorted by matching its name with filteredString
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
    private var showsGroups = true
    private var showingLessRows = true
    private var numberHiddenShownRows = 3 // Displays only [numberHiddenShownRows] if showingLessRows is true

    private var sections: [Section] = []

    // More Section and count
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
        get { return moreSection?.filteredItems.count ?? 0 }
    }

    // Your section and count
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
        get { return yourSection?.filteredItems.count ?? 0 }
    }


    // Initialization
    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func createForInterests() -> EditingViewController {
        let editingVC = EditingViewController()
        editingVC.showsGroups = false
        return editingVC
    }

    static func createForGroups() -> EditingViewController {
        let editingVC = EditingViewController()
        editingVC.showsGroups = true
        return editingVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit \(showsGroups ? "Groups" : "Interests")"
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

        // Setup Sections
        // TODO replace with actual data
        let yourInterests: [Interest] = [
            Interest(name: "Art", categories: "lorem, lorem, lorem, lorem, lorem", image: "art"),
            Interest(name: "Business", categories: "lorem, lorem, lorem, lorem, lorem", image: "business"),
            Interest(name: "Dance", categories: "lorem, lorem, lorem, lorem, lorem", image: "dance")
        ]
        let moreInterests: [Interest] = [
            Interest(name: "Design", categories: "lorem, lorem, lorem, lorem, lorem", image: "design"),
            Interest(name: "Fashion", categories: "lorem, lorem, lorem, lorem, lorem", image: "fashion"),
            Interest(name: "Fitness", categories: "lorem, lorem, lorem, lorem, lorem", image: "fitness"),
            Interest(name: "Food", categories: "lorem, lorem, lorem, lorem, lorem", image: "food"),
            Interest(name: "Humanities", categories: "lorem, lorem, lorem, lorem, lorem", image: "humanities"),
            Interest(name: "Music", categories: "lorem, lorem, lorem, lorem, lorem", image: "music"),
            Interest(name: "Photography", categories: "lorem, lorem, lorem, lorem, lorem", image: "photography"),
            Interest(name: "Reading", categories: "lorem, lorem, lorem, lorem, lorem", image: "reading"),
            Interest(name: "Sustainability", categories: "lorem, lorem, lorem, lorem, lorem", image: "sustainability"),
            Interest(name: "Technology", categories: "lorem, lorem, lorem, lorem, lorem", image: "tech"),
            Interest(name: "Travel", categories: "lorem, lorem, lorem, lorem, lorem", image: "travel"),
            Interest(name: "TV & Film", categories: "lorem, lorem, lorem, lorem, lorem", image: "tvfilm")
        ]
        let yourGroups: [Group] = [
            Group(name: "Apple", image: ""),
            Group(name: "banana", image: ""),
            Group(name: "Cornell AppDev", image: "")
        ]
        let moreGroups: [Group] = [
            Group(name: "dandelion", image: ""),
            Group(name: "giraffe", image: ""),
            Group(name: "heap", image: ""),
            Group(name: "Igloo", image: ""),
            Group(name: "Jeans", image: "")
        ]

        let yourSection: Section
        let moreSection: Section
        if showsGroups {
            yourSection = Section(type: .yours, items: yourGroups.map { .group($0) })
            moreSection = Section(type: .more, items: moreGroups.map { .group($0) })
        } else {
            yourSection = Section(type: .yours, items: yourInterests.map { .interest($0) })
            moreSection = Section(type: .more, items: moreInterests.map { .interest($0) })
        }
        sections = [yourSection, moreSection]

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.shadowImage = UIImage() // Hide navigation bar bottom shadow
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(.medium, size: 24)
        ]

        backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        backButton.imageView?.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 10, height: 20))
        }
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        saveBarButtonItem.title = "Save"
        saveBarButtonItem.tintColor = .darkGreen
        saveBarButtonItem.setTitleTextAttributes([
            .font: UIFont.getFont(.medium, size: 20)
        ], for: .normal)
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
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
            if showingLessRows && yourSectionSize > numberHiddenShownRows {
                return numberHiddenShownRows
            } else {
                return yourSectionSize
            }

        case .more:
            return moreSectionSize
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let itemType = section.filteredItems[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingTableViewCell.reuseIdentifier, for: indexPath) as? OnboardingTableViewCell else { return UITableViewCell() }

        cell.changeColor(isSelected: section.type == .yours)

        switch itemType {
        case .interest(let interest):
            cell.configure(with: interest)
        case .group(let group):
            cell.configure(with: group)
        }

        cell.selectionChangesAppearence = false

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EditHeaderView()
        let section = sections[section]
        let labelTitle: String
        let labelSubtext : String

        switch section.type {
        case .yours:
            labelTitle = showsGroups ? "Your Groups" : "Your Interests"
            if yourSectionSize == 0 {
                labelSubtext = showsGroups
                    ? "Select a group so we can better help you find a pair!"
                    : "Select at least one interest so we can better help you find a pair!"
            } else {
                labelSubtext = "tap to deselect"
            }
            headerView.configure(with: labelTitle, info: labelSubtext, useSearch: false)

        case .more:
            labelTitle = showsGroups ? "More Groups" : "More Interests"
            labelSubtext = showsGroups ? "tap or search to add" : "tap to add"
            headerView.configure(with: labelTitle, info: labelSubtext, useSearch: showsGroups)

            if showsGroups {
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
        if section == 0 && yourSectionSize > numberHiddenShownRows {
            let footerView = EditFooterView(showsGroups: showsGroups)
            footerView.changeViewState(isShowingLess: showingLessRows)
            footerView.delegate = {
                self.showingLessRows = $0
                self.tableView.reloadData()
            }

            return footerView
        } else {
            return UIView()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return showsGroups && section == 1 ? 128 : 86
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return yourSectionSize > numberHiddenShownRows && section == 0 ? 64 : 0
    }

}

// MARK: - UITableView Header
private class EditHeaderView: UIView, UISearchBarDelegate {

    private let stackView = UIStackView()
    private let label = UILabel()
    private var searchBar: UISearchBar?

    /// Callback when search text is changed
    var searchDelegate: ((String?) -> Void)?

    func configure(with title: String, info: String, useSearch: Bool) {
        setupText(title: title, info: info)
        setupViews(withSearch: useSearch)
        setupConstraints()
    }

    private func setupText(title: String, info: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0.0
        style.alignment = .center
        let primaryAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._20CircularStdMedium as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.textBlack
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

    private func setupViews(withSearch: Bool) {
        label.numberOfLines = 0
        if withSearch {
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
        searchBar.searchTextField.textColor = .textBlack
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
        let seachbarSize = CGSize(width: 290, height: 42)
        let stackPadding = 12

        label.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        searchBar?.snp.makeConstraints { make in
            make.size.equalTo(seachbarSize)
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

    private let showingGroups: Bool
    private var showingLessRows = false

    private let stack = UIStackView()
    private let label = UILabel()
    private let arrowView = UIImageView()

    var delegate: ((Bool) -> Void)?

    init(showsGroups: Bool) {
        showingGroups = showsGroups
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

        stack.isUserInteractionEnabled = false
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 12
        stack.insertArrangedSubview(arrowView, at: 0)
        stack.insertArrangedSubview(label, at: 1)
        addSubview(stack)

        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
    }

    private func setupConstraints() {
        arrowView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 9, height: 18))
        }

        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(44)
        }
    }

    func changeViewState(isShowingLess: Bool) {
        showingLessRows = isShowingLess

        if showingLessRows {
            label.text = "View your other \(showingGroups ? "groups" : "interests")"
            arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        } else {
            label.text = "View fewer \(showingGroups ? "groups" : "interests")"
            arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }

        delegate?(showingLessRows)
    }

    @objc func buttonPressed() {
        changeViewState(isShowingLess: !showingLessRows)

    }

    func configure() {
        label.text = showingGroups ? "view your other groups" : "view your other interests"
    }

}
