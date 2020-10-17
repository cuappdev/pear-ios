//
//  InterestsViewController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/3/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class InterestsViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let nextButton = UIButton()
    private let fadeTableView = FadeWrapperView<UITableView>(UITableView(frame: .zero, style: .plain), fadeColor: .backgroundLightGreen)
    private let titleLabel = UILabel()

    // MARK: - Data
    private weak var delegate: OnboardingPageDelegate?
    private var interests: [Interest] = [
        Interest(name: "Art", categories: "painting, crafts, embroidery...", image: "art"),
        Interest(name: "Business", categories: "entrepreneurship, finance, VC...", image: "business"),
        Interest(name: "Dance", categories: "urban, hip hop, ballet, swing...", image: "dance"),
        Interest(name: "Design", categories: "UI/UX, graphic, print...", image: "design"),
        Interest(name: "Fashion", categories: "", image: "fashion"),
        Interest(name: "Fitness", categories: "working out, outdoors, basketball...", image: "fitness"),
        Interest(name: "Food", categories: "cooking, eating, baking...", image: "food"),
        Interest(name: "Humanities", categories: "history, politics...", image: "humanities"),
        Interest(name: "Music", categories: "instruments, producing, acapella...", image: "music"),
        Interest(name: "Photography", categories: "digital, analog...", image: "photography"),
        Interest(name: "Reading", categories: "", image: "reading"),
        Interest(name: "Sustainability", categories: "", image: "sustainability"),
        Interest(name: "Tech", categories: "programming, web/app development...", image: "tech"),
        Interest(name: "Travel", categories: "road trips, backpacking...", image: "travel"),
        Interest(name: "TV & Film", categories: "", image: "tvfilm")
    ]
    private var selectedInterests: [Interest] = []
    private let userDefaults = UserDefaults.standard

    init(delegate: OnboardingPageDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        titleLabel.text = "What do you love?"
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.allowsMultipleSelection = true
        fadeTableView.view.bounces = false
        fadeTableView.view.showsHorizontalScrollIndicator = false
        fadeTableView.view.showsVerticalScrollIndicator = false
        fadeTableView.view.separatorStyle = .none
        fadeTableView.view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
        fadeTableView.view.delegate = self
        fadeTableView.view.dataSource = self
        fadeTableView.view.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
        view.addSubview(fadeTableView)

        nextButton.setTitle("Next", for: .normal)
        nextButton.layer.cornerRadius = 27
        nextButton.isEnabled = false
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        setupConstraints()
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 0)
    }

    @objc func nextButtonPressed() {
        delegate?.nextPage(index: 2)
        let userInterests = selectedInterests.map { $0.name }
        userDefaults.set(userInterests, forKey: Constants.UserDefaults.userInterests)
        delegate?.nextPage(index: 2)
    }

    private func setupConstraints() {
        let tableViewTopPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 48)
        let tableViewBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 44)
        let titleHeight: CGFloat = 30

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }

        fadeTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
            make.top.equalTo(titleLabel.snp.bottom).offset(tableViewTopPadding)
            make.bottom.equalTo(nextButton.snp.top).offset(-tableViewBottomPadding)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }
    }


    /// Updates the enabled state of next button based on the state of selectedInterests.
    private func updateNext() {
        nextButton.isEnabled = selectedInterests.count > 0
        if nextButton.isEnabled {
            nextButton.backgroundColor = .backgroundOrange
            nextButton.layer.shadowColor = UIColor.black.cgColor
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            nextButton.layer.shadowOpacity = 0.15
            nextButton.layer.shadowRadius = 2
        } else {
            nextButton.backgroundColor = .inactiveGreen
            nextButton.layer.shadowColor = .none
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            nextButton.layer.shadowOpacity = 0
            nextButton.layer.shadowRadius = 0
        }
    }

}

// MARK: TableViewDelegate
extension InterestsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterests.append(interests[indexPath.row])
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedInterests.removeAll { $0.name == interests[indexPath.row].name}
        updateNext()
    }

}

// MARK: TableViewDataSource
extension InterestsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            OnboardingTableViewCell.reuseIdentifier, for: indexPath) as?
        OnboardingTableViewCell else { return UITableViewCell() }
        let data = interests[indexPath.row]
        cell.configure(with: data)
        return cell
    }

}
