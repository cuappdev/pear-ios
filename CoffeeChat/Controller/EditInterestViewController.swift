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
    private let backButton = UIButton()
    private let saveBarButtonItem = UIBarButtonItem()

    // MARK: - Display Settings
    private var showingLess = true
    private var hideAfter = 3 // DOesn't display more [hideAfter] categories if showingLess is true

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
        return section == 0
            ? (showingLess && yourInterests.count > hideAfter ? 3 : yourInterests.count)
            : moreInterests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingTableViewCell.reuseIdentifier, for: indexPath) as? OnboardingTableViewCell else { return UITableViewCell() }
        let data = (indexPath.section == 0 ? yourInterests : moreInterests)[indexPath.row]
        cell.configure(with: data)
        cell.changeColor(isSelected: indexPath.section == 0)
        cell.selectionChangesAppearence(false)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView
        if section == 0 && yourInterests.isEmpty {
            headerView = EditHeaderView(with: "Your Interests", info: "Select at least one interest so we can better help you find a pair!")
        } else if section == 0 { // Upper Section
            headerView = EditHeaderView(with: "Your Interests", info: "Tap to deselect")
        } else { // Lower Section
            headerView = EditHeaderView(with: "More Interests", info: "Tap to select")
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && yourInterests.count > hideAfter {
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
        return 64 + 12
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return yourInterests.count > hideAfter && section == 0 ? 64 : 0
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
        print("b4 less: \(showingLess)")
        showingLess = less
        print("showing less: \(showingLess)")
        label.text = less ? "View your other interests" : "View fewer interests"
        arrowView.transform = less
            ? CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
            : CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        delegate?(showingLess)
        print("on exit less: \(showingLess)")
    }

    @objc private func buttonAction() {
        print("?")
        changeViewState(less: !showingLess)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String) {
        label.text = title
    }

}
