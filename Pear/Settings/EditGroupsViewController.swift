//
//  EditGroupsViewController.swift
//  Pear
//
//  Created by Lucy Xu on 6/8/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

// MARK: - UIViewController
class EditGroupsViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let saveBarButtonItem = UIBarButtonItem()
    private let fadeTableView = FadeWrapperView(
        UITableView(frame: .zero, style: .grouped), fadeColor: .backgroundLightGreen)

    // MARK: - Display Settings
    private var isCollapsed = true
    private var numRowsShownWhenCollapsed = 3

    private var sections: [EditSection<Group>] = []
    private let user: UserV2

    // moreSection refers to the categories the user has not selected.
    // Selecting something in this section would add it to `yourSection`.
    private var moreSection: EditSection<Group>? {
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
    private var yourSection: EditSection<Group>? {
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
    init(user: UserV2) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Groups"
        view.backgroundColor = .backgroundLightGreen

        fadeTableView.view.delegate = self
        fadeTableView.view.dataSource = self
        fadeTableView.view.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
        fadeTableView.view.isScrollEnabled = true
        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.allowsMultipleSelection = true
        fadeTableView.view.bounces = true
        fadeTableView.view.showsHorizontalScrollIndicator = false
        fadeTableView.view.showsVerticalScrollIndicator = false
        fadeTableView.view.separatorStyle = .none
        fadeTableView.view.sectionFooterHeight = 0
        view.addSubview(fadeTableView)

        fadeTableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(39)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

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

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupSections() {
        setupSectionsFromGroups()
        sections = [
            EditSection<Group>(type: .yours, items: []),
            EditSection<Group>(type: .more, items: [])
        ]
        fadeTableView.view.reloadData()
    }

    private func setupSectionsFromGroups() {
        NetworkManager.getAllGroups { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groups):
                DispatchQueue.main.async {
                    let nonselectedGroups = groups.filter { group in
                        !self.user.groups.contains { userGroup in
                            userGroup.id == group.id
                        }
                    }
                    self.sections = [
                        EditSection<Group>(type: .yours, items: self.user.groups),
                        EditSection<Group>(type: .more, items: nonselectedGroups)
                    ]
                    self.fadeTableView.view.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
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
            make.size.equalTo(Constants.Onboarding.backButtonSize)
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

        let selectedGroups = yourSection.items.map { $0.id }

        NetworkManager.updateGroups(groups: selectedGroups) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.present(UIAlertController.getStandardErrortAlert(), animated: true)
            }
        }
    }

    /// Moves an interest or group with name identifier from a source section to the target section
    private func moveData(named name: String, from source: EditSection<Group>, to target: EditSection<Group>) {
        let removed = source.removeItem(named: name)
        if let removed = removed { target.addItem(removed) }
    }

}

// MARK: - UITableViewDelegate
extension EditGroupsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let group = section.filteredItems[indexPath.row]

        let itemName = group.name
        guard let yourSection = yourSection else { return }
        guard let moreSection = moreSection else { return }

        switch section.type {
        case .yours:
            moveData(named: itemName, from: yourSection, to: moreSection)
        case .more:
            moveData(named: itemName, from: moreSection, to: yourSection)
        }

        fadeTableView.view.reloadData()
    }

}

// MARK: - UITableViewDataSource
extension EditGroupsViewController: UITableViewDataSource {

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
        let group = section.filteredItems[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: OnboardingTableViewCell.reuseIdentifier,
                            for: indexPath
                        ) as? OnboardingTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: group)
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
            labelTitle = "Your Groups"
            if yourSectionSize == 0 {
                labelSubtext =  "Select a group so we can better help you find a pair!"
                saveBarButtonItem.isEnabled = false
            } else {
                labelSubtext = "tap to deselect"
                saveBarButtonItem.isEnabled = true
            }
            headerView.configure(with: labelTitle, info: labelSubtext, shouldIncludeSearchBar: false)

        case .more:
            labelTitle = "More Groups"
            labelSubtext = "tap or search to add"
            headerView.configure(with: labelTitle, info: labelSubtext, shouldIncludeSearchBar: true)

            headerView.searchDelegate = { searchText in
                self.moreSection?.filterString = searchText
                self.moreSection?.refilter()
                self.fadeTableView.view.reloadData()
            }

        }

        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && yourSectionSize > numRowsShownWhenCollapsed {
            let footerView = EditFooterView()
            footerView.sectionIsCollapsed = isCollapsed
            footerView.updateViewState()
            footerView.delegate = {
                self.isCollapsed = $0
                self.fadeTableView.view.reloadData()
                self.fadeTableView.view.setNeedsLayout()
            }

            return footerView
        } else {
            return UIView()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        EditSectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 1 ? 128 : 86
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
        searchBar.searchTextField.clearButtonMode = .whileEditing

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

    var sectionIsCollapsed = false

    private let arrowView = UIImageView()
    private let label = UILabel()
    private let stackView = UIStackView()

    var delegate: ((Bool) -> Void)?

    init() {
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
        arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))

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
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }
    }

    func updateViewState() {
        if sectionIsCollapsed {
            label.text = "View your other groups"
            arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        } else {
            label.text = "View fewer groups"
            arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }

        delegate?(sectionIsCollapsed)
    }

    @objc func buttonPressed() {
        sectionIsCollapsed.toggle()
        updateViewState()
    }

    func configure() {
        label.text = "view your other groups"
    }

}

extension EditGroupsViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
            navigationController?.popViewController(animated: true)
        }
        return false
    }

}

