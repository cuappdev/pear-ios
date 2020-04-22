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
    private func getInterestFromIndexPath(_ indexPath: IndexPath) -> Interest {
        return indexPath.section < yourInterests.count
            ? yourInterests[indexPath.section]
            : moreInterests[indexPath.section - yourInterests.count]
    }

}

// MARK: - UITableViewDelegate
extension EditInterestViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let interest = getInterestFromIndexPath(indexPath)
        if indexPath.section < yourInterests.count { // From Top Section
            if let location = yourInterests.firstIndex(where: { $0.name == interest.name }) {
                yourInterests.remove(at: location)
            }
            moreInterests.append(interest)
            moreInterests.sort(by: {$0.name < $1.name })
        } else { // Bottom Section
            if let location = moreInterests.firstIndex(where: { $0.name == interest.name }) {
                moreInterests.remove(at: location)
            }
            yourInterests.append(interest)
            yourInterests.sort(by: {$0.name < $1.name })
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension EditInterestViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            OnboardingTableViewCell.reuseIdentifier, for: indexPath) as?
            OnboardingTableViewCell else { return UITableViewCell() }

        let data = getInterestFromIndexPath(indexPath)
        cell.configure(with: data)
        cell.selectionChangesAppearence(false)
        cell.contentView.backgroundColor = indexPath.section < yourInterests.count ? .pearGreen : .white
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacing: CGFloat = 12
        let headerSpacing: CGFloat = 88
        return [0, yourInterests.count].contains(section) ? headerSpacing : cellSpacing
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView

        if section == yourInterests.count { // Lower Section
            headerView = InterestHeaderView()
            (headerView as? InterestHeaderView)?.configure(with: "More Interests", info: "Tap to select")
            headerView.backgroundColor = .none
        } else if section == 0 { // Upper Section
            headerView = InterestHeaderView()
            (headerView as? InterestHeaderView)?.configure(with: "Your Interests", info: "Tap to deselect")
            headerView.backgroundColor = .none
        } else { // Filler Space
            headerView = UIView()
        }
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return yourInterests.count + moreInterests.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

}

// MARK: - UITableView Header
private class InterestHeaderView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.numberOfLines = 0
        addSubview(label)
        label.snp.makeConstraints { make in
          make.centerY.equalToSuperview().offset(12)
          make.centerX.equalToSuperview()
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
