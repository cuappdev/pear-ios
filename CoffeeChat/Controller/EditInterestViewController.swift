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
    private var yourInterests: [Interest] = []
    private var moreInterests: [Interest] = []

    private var interests: [Interest] = [
        Interest(name: "Art", categories: "lorem, lorem, lorem, lorem, lorem", image: "art"),
        Interest(name: "Business", categories: "lorem, lorem, lorem, lorem, lorem", image: "business"),
        Interest(name: "Dance", categories: "lorem, lorem, lorem, lorem, lorem", image: "dance"),
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

        // TODO Example
        let split = 3 // interests.count / 2
        yourInterests = Array(interests[0..<split])
        moreInterests = Array(interests[split..<interests.count])
        print(yourInterests)
        print(moreInterests)

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
        //interestsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        view.addSubview(interestsTableView)

        interestsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(39)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

// MARK: - UITableViewDelegate
extension EditInterestViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect")
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

        print("index path: \(indexPath.row) ,  \(indexPath.section)")
        print("sizeof yours: \(yourInterests.count)")
        print("sizeof more: \(moreInterests.count)")
        let data = indexPath.section < yourInterests.count
            ? yourInterests[indexPath.section]
            : moreInterests[indexPath.section - yourInterests.count]
        cell.configure(with: data)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Spacing
        let cellSpacing: CGFloat = 12
        let headerSpacing: CGFloat = 88
        // Location of where header should be
        let headerLocations = [0, yourInterests.count]
        // Header
        return headerLocations.contains(section) ? headerSpacing : cellSpacing
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Location of where header should be
        let headerLocations = [0, yourInterests.count]
        // Header
        let headerView: UIView
        if headerLocations.contains(section) { // Section Header
            headerView = InterestHeaderView()
            if let headerView = headerView as? InterestHeaderView {
                headerView.configure(with: "HEADER", info: "Is this working?")
                headerView.backgroundColor = .none
            }
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
          make.center.equalToSuperview().offset(12)
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
            .font: UIFont._20CircularStdBold as Any,
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
