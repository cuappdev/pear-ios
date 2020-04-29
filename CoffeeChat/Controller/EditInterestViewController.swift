//
//  EditInterestVireController.swift
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
enum SectionType {
    case yours
    case more
}
struct Section {
    let type: SectionType
    var items: [ItemType]
}

// MARK: - UIViewController
class EditInterestViewController: UIViewController {

    // MARK: - Private View Vars
    private let interestsTableView = UITableView(frame: .zero, style: .grouped)
    private let backButton = UIButton()
    private let saveBarButtonItem = UIBarButtonItem()

    // MARK: - Display Settings
    private var showingLess = true
    private var hideAfter = 3 // Doesn't display more [hideAfter] categories if showingLess is true

    private var sections: [Section] = []
    private var moreSection: Section? {
        get {
            if let loc = sections.firstIndex(where: { $0.type == .more }) {
                return sections[loc]
            } else { return nil }
        }
    }
    private var moreCount: Int {
        get {
            return moreSection?.items.count ?? 0
        }
    }
    private var yourSection: Section? {
        get {
            if let loc = sections.firstIndex(where: { $0.type == .yours }) {
                return sections[loc]
            } else { return nil }
        }
    }
    private var yourCount: Int {
        get {
            return yourSection?.items.count ?? 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Groups"
        view.backgroundColor = .backgroundLightGreen

        interestsTableView.delegate = self
        interestsTableView.dataSource = self
        interestsTableView.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
        interestsTableView.isScrollEnabled = true
        interestsTableView.clipsToBounds = true
        interestsTableView.backgroundColor = .none
        interestsTableView.allowsMultipleSelection = true
        interestsTableView.bounces = false
        interestsTableView.showsHorizontalScrollIndicator = false
        interestsTableView.showsVerticalScrollIndicator = false
        interestsTableView.separatorStyle = .none
        interestsTableView.sectionFooterHeight = 0
        view.addSubview(interestsTableView)

        interestsTableView.snp.makeConstraints { make in
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


        let yourSection = Section(type: .yours, items: yourInterests.map { ItemType.interest($0) })
        let moreSection = Section(type: .more, items: moreInterests.map { ItemType.interest($0) })
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

    // MARK: - Section Manipulation
    /// Moves an interest or group with name identifier from a source section to the target section
    private func moveData(named name: String, from source: SectionType, to target: SectionType) {
        if
            let sourceIndx = sections.firstIndex(where: { $0.type == source }),
            let targetIndx = sections.firstIndex(where: { $0.type == target }) {
            var sourceSection = sections[sourceIndx]
            var targetSection = sections[targetIndx]
            if let loc = sourceSection.items.firstIndex(where: { $0.getName() == name }) {
                targetSection.items.append(sourceSection.items[loc])
                sourceSection.items.remove(at: loc)
                sections[sourceIndx] = sourceSection
                sections[sourceIndx].items.sort(by: { $0.getName() < $1.getName() })
                sections[targetIndx] = targetSection
                sections[targetIndx].items.sort(by: { $0.getName() < $1.getName() })
            }
        }
    }

}

// MARK: - UITableViewDelegate
extension EditInterestViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]

        switch item {
        case .interest(let interest):
            let name = interest.name
            print(name)
            switch section.type {
            case .yours:
                moveData(named: name, from: .yours, to: .more)
            case .more:
                moveData(named: name, from: .more, to: .yours)
            }

        case .group(let group):
            // TODO
            break
        }

        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension EditInterestViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0
            ? (showingLess && yourCount > hideAfter ? 3 : yourCount)
            : moreCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let itemType = section.items[indexPath.row]

        switch itemType {
        case .interest(let interest):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingTableViewCell.reuseIdentifier, for: indexPath) as? OnboardingTableViewCell else { return UITableViewCell() }
            cell.configure(with: interest)
            cell.changeColor(isSelected: section.type == .yours)
            cell.selectionChangesAppearence(false)
            return cell

        case .group(let group):
            // TODO
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView
        if section == 0 && yourCount == 0 {
            headerView = EditHeaderView(with: "Your Interests", info: "Select at least one interest so we can better help you find a pair!")
        } else if section == 0 { // Upper Section
            headerView = EditHeaderView(with: "Your Interests", info: "Tap to deselect")
        } else { // Lower Section
            headerView = EditHeaderView(with: "More Interests", info: "Tap to select")
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && yourCount > hideAfter {
            let footerView = EditFooterView(with: "View your other interests")
            footerView.changeViewState(less: showingLess)
            footerView.delegate = {
                self.showingLess = $0
                self.interestsTableView.reloadData()
            }
            return footerView
        } else {
            return UIView()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (yourSection?.items.count ?? 0) > hideAfter && section == 0 ? 64 : 0
    }

}

// MARK: - UITableView Header
private class EditHeaderView: UIButton {

    private let label = UILabel()

    convenience init(with title: String, info: String) {
        self.init(frame: .zero)
        configure(with: title, info: info)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.numberOfLines = 0
        addSubview(label)
        label.snp.makeConstraints { make in
          make.centerY.equalToSuperview().offset(12)
          make.centerX.equalToSuperview()
          make.width.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, info: String) {
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

        let titleStr = NSMutableAttributedString(string: "\(title)\n", attributes: primaryAttributes)
        let infoStr = NSMutableAttributedString(string: info, attributes: secondaryAttributes)
        let combined = NSMutableAttributedString()
        combined.append(titleStr)
        combined.append(infoStr)
        label.attributedText = combined
    }

}

// MARK: UITableViewFooter
private class EditFooterView: UIButton {

    private var showingLess = false

    private let label = UILabel()
    private let arrowView = UIImageView()

    var delegate: ((Bool) -> Void)?

    convenience init(with text: String) {
        self.init(frame: .zero)
        label.font = UIFont._16CircularStdMedium
        label.textColor = .greenGray
        configure(with: text)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.numberOfLines = 0
        label.isUserInteractionEnabled = false
        addSubview(label)

        arrowView.image = UIImage(named: "right_arrow")
        arrowView.isUserInteractionEnabled = false
        arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        arrowView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 9, height: 18))
        }

        let stack = UIStackView()
        stack.isUserInteractionEnabled = false
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillProportionally
        stack.insertArrangedSubview(arrowView, at: 0)
        stack.insertArrangedSubview(label, at: 1)
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(44)
        }

        addTarget(self, action: #selector(buttonAction), for: .touchDown)
    }

    func changeViewState(less: Bool) {
        showingLess = less
        label.text = less ? "View your other interests" : "View fewer interests"
        arrowView.transform = less
            ? CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
            : CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        delegate?(showingLess)
    }

    @objc private func buttonAction() {
        changeViewState(less: !showingLess)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String) {
        label.text = title
    }

}
