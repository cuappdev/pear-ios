
// TODO <--
// Make cells use padding to enforce itercell spacing
// Reconstruct this so its by sectinos, queing different cell types for things
// Header is the select thing (has search bar for groups)
// Footer for top section is the button with vieweing more or less
// IDEALLY dequeing is easy as its all same cell, headers displat even id seciont is empty, footer doesn't show if its
// empty



//
//  EditInterestVireController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 3/11/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

// MARK: - UIViewController
class EditInterestViewController: UIViewController {

    // MARK: - Private View Vars
    private let interestsTableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Collection View Sections
    private enum Section {
        case yourInterests([Interest])
        case moreInterests([Interest])
    }

    // MARK: - Data Vars
    // TODO replace with actual data
    private var yourInterests: [Interest] = [
        Interest(name: "Art", categories: "lorem, lorem, lorem, lorem, lorem", image: "art"),
        Interest(name: "Business", categories: "lorem, lorem, lorem, lorem, lorem", image: "business"),
        Interest(name: "Dance", categories: "lorem, lorem, lorem, lorem, lorem", image: "dance")
    ]
    private var moreInterests: [Interest] = [
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

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    // MARK: - Data Management
    // private func getInterestFromIndexPath(_ indexPath: IndexPath) -> Interest {
    //     return indexPath.section < yourInterests.count
    //         ? yourInterests[indexPath.section]
    //         : moreInterests[indexPath.section - yourInterests.count]
    // }

}

// MARK: - UITableViewDelegate
extension EditInterestViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = (indexPath.section == 0 ? yourInterests : moreInterests)[indexPath.row]
        if indexPath.section == 0 { // From Top Section
            if let location = yourInterests.firstIndex(where: { $0.name == data.name }) {
                yourInterests.remove(at: location)
            }
            moreInterests.append(data)
            moreInterests.sort(by: {$0.name < $1.name })
        } else { // Bottom Section
            if let location = moreInterests.firstIndex(where: { $0.name == data.name }) {
                moreInterests.remove(at: location)
            }
            yourInterests.append(data)
            yourInterests.sort(by: {$0.name < $1.name })
        }
        print("your: \(yourInterests)")
        print("your count: \(yourInterests.count)")
        print("more: \(moreInterests)")
        print("more count: \(moreInterests.count)")
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension EditInterestViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? yourInterests.count : moreInterests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell.configure(with: "Your Interests", info: "Select at least one interest so that we can better help you find a Pear!")

        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingTableViewCell.reuseIdentifier, for: indexPath) as? OnboardingTableViewCell else { return UITableViewCell() }
        let data = (indexPath.section == 0 ? yourInterests : moreInterests)[indexPath.row]
        cell.configure(with: data)
        cell.changeColor(isSelected: indexPath.section == 0)
        cell.selectionChangesAppearence(false)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // let cellSpacing: CGFloat = 12
        // let headerSpacing: CGFloat = 88
        // if yourInterests.isEmpty {
        //     return section == 1 ? headerSpacing : cellSpacing
        // } else {
        //     return [0, yourInterests.count].contains(section) ? headerSpacing : cellSpacing
        // }
        return 88
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // if yourInterests.isEmpty { // Empty Your Interests section
        //     if section == 0 { // Empty Your Interests section
        //         // headerView = InterestHeaderView(with: "Your Interests", info: "Select at least one interest so we can better help you find a pair!")
        //         headerView = UIView()
        //     } else if section == 1 { // More Interests section
        //         headerView = InterestHeaderView(with: "More Interests", info: "Tap to select")
        //     } else { // Filler Spacing
        //         headerView = UIView()
        //     }
        // } else { // Normal Display
        //     if section == 0 { // Upper Section
        //         headerView = InterestHeaderView(with: "Your Interests", info: "Tap to deselect")
        //     } else if section == yourInterests.count { // Lower Section
        //         headerView = InterestHeaderView(with: "More Interests", info: "Tap to select")
        //     } else { // Filler Spacing
        //         headerView = UIView()
        //     }
        // }
        let headerView: UIView
        if section == 0 && yourInterests.isEmpty {
            headerView = InterestHeaderView(with: "Your Interests", info: "Select at least one interest so we can better help you find a pair!")
        } else if section == 0 { // Upper Section
            headerView = InterestHeaderView(with: "Your Interests", info: "Tap to deselect")
        } else { // Lower Section
            headerView = InterestHeaderView(with: "More Interests", info: "Tap to select")
        }
        headerView.backgroundColor = .none
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 + 12
    }

}

// MARK: - UITableView Header
private class InterestHeaderView: UIView {

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

// MARK: EmptyTableViewCell
private class EmptyTableViewCell: UITableViewCell {

    private let headerView = InterestHeaderView()
    static let reuseIdentifier = "EmptyEditTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, info: String) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        headerView.configure(with: title, info: info)
    }

}
