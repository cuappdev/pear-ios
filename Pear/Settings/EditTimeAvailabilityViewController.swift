//
//  EditTimeAvailabilityViewController.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/17/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class EditTimeAvailabilityViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private var dayCollectionView: UICollectionView!
    private let dayLabel = UILabel()
    private let saveBarButtonItem = UIBarButtonItem()
    private let scheduleTimeLabel = UILabel()
    private var timeCollectionView: UICollectionView!
    private let timezoneLabel = UILabel()

    // MARK: - Time Data Vars
    private let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    private let timeInteritemSpacing: CGFloat = 4
    // The times to display in timeCollectionView
    private var timeSections: [TimeSection] = []

    // For times presented to user for parts of a day
    private let afternoonTimes = Time.allAfternoonTimes
    private let eveningTimes = Time.allEveningTimes
    private let morningTimes = Time.allMorningTimes

    // For section items with a header and times
    private var afternoonItems: [ItemType] = []
    private var eveningItems: [ItemType] = []
    private var morningItems: [ItemType] = []

    private var availabilities: [[String]] = []
    private var selectedDay: String = "Su"

    init(availabilities: [String]) {
        for availability in availabilities {
            let availabilityTimes = availability.split(separator: ",").map { (e) -> String in
                print(e, Time.floatToStringTime(time: Float(e)!))
                return Time.floatToStringTime(time: Float(e)!)
            }
            self.availabilities.append(availabilityTimes)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        title = "Edit Availability"
        setupNavigationBar()

        morningItems = [ItemType.header("Morning")] + morningTimes.map { ItemType.time($0) }
        afternoonItems = [ItemType.header("Afternoon")] + afternoonTimes.map { ItemType.time($0) }
        eveningItems = [ItemType.header("Evening")] + eveningTimes.map { ItemType.time($0) }

        timeSections = [
            TimeSection(type: .morning, items: morningItems),
            TimeSection(type: .afternoon, items: afternoonItems),
            TimeSection(type: .morning, items: eveningItems)
        ]

        scheduleTimeLabel.font = ._20CircularStdBook
        scheduleTimeLabel.text = "When are you free?"
        scheduleTimeLabel.textColor = .black
        view.addSubview(scheduleTimeLabel)

        let dayCollectionViewLayout = UICollectionViewFlowLayout()
        dayCollectionViewLayout.minimumInteritemSpacing = timeInteritemSpacing
        dayCollectionViewLayout.scrollDirection = .horizontal

        dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: dayCollectionViewLayout)
        dayCollectionView.allowsSelection = true
        dayCollectionView.backgroundColor = .clear
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
        dayCollectionView.register(SchedulingDayCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingDayCollectionViewCell.reuseIdentifier)
        dayCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(dayCollectionView)

        guard let day = Time.daysDict[selectedDay] else { return }
        dayLabel.text = "Every \(day)"
        dayLabel.textColor = .black
        dayLabel.font = ._20CircularStdBook
        view.addSubview(dayLabel)

        timezoneLabel.text = "All times are in eastern time"
        timezoneLabel.textColor = .greenGray
        timezoneLabel.font = ._16CircularStdBook
        view.addSubview(timezoneLabel)

        let timeCollectionViewLayout = UICollectionViewFlowLayout()
        timeCollectionViewLayout.minimumInteritemSpacing = timeInteritemSpacing
        timeCollectionViewLayout.sectionInset = sectionInsets
        timeCollectionViewLayout.scrollDirection = .horizontal

        timeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timeCollectionViewLayout)
        timeCollectionView.allowsMultipleSelection = true
        timeCollectionView.backgroundColor = .clear
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.register(SchedulingTimeCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingTimeCollectionViewCell.reuseIdentifier)
        view.addSubview(timeCollectionView)

        setupConstraints()
    }

    private func setupNavigationBar() {
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
        saveBarButtonItem.action = #selector(saveAvailability)
        saveBarButtonItem.setTitleTextAttributes([
            .font: UIFont.getFont(.medium, size: 20)
        ], for: .normal)
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveAvailability() {
        var savedAvailabilities: [String] = []
        for a in availabilities {
            let s = a.map {
                "\(Time.stringTimeToFloat(time: $0))"
            }
            savedAvailabilities.append(s.joined(separator: ","))
        }

        NetworkManager.updateAvailability(availabilities: savedAvailabilities) { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
    }

    private func setupConstraints() {
        scheduleTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }

        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleTimeLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(Time.daysAbbrev.count * 45)
        }

        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        timezoneLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        timeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(timezoneLabel.snp.bottom).offset(20)
            make.height.equalTo(400)
            make.width.equalTo(timeSections.count * 105)
            make.centerX.equalToSuperview()
        }
    }

}

extension EditTimeAvailabilityViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionView == dayCollectionView ? 1 : timeSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == dayCollectionView ? Time.daysAbbrev.count : timeSections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dayCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SchedulingDayCollectionViewCell.reuseIdentifier,
                    for: indexPath
            ) as? SchedulingDayCollectionViewCell else {
                return UICollectionViewCell()
            }
            let day = Time.daysAbbrev[indexPath.item]
            cell.configure(for: day)
            let hasBeenSelected = availabilities[indexPath.item].count > 0
            cell.updateBackgroundColor(isAvailable: hasBeenSelected)

            if day == selectedDay {
                dayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                cell.isSelected = true
            }
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SchedulingTimeCollectionViewCell.reuseIdentifier,
                for: indexPath
        ) as? SchedulingTimeCollectionViewCell else {
            return  UICollectionViewCell()
        }
        let section = timeSections[indexPath.section]
        let item = section.items[indexPath.row]
        switch item {
        case .header(let header):
            cell.configure(for: header, isHeader: true)
            cell.isUserInteractionEnabled = false
        case .time(let time):
            cell.configure(for: time, isHeader: false)
            cell.isUserInteractionEnabled = true

            if let dayIndex = Time.daysAbbrev.firstIndex(of: selectedDay),
               availabilities[dayIndex].contains(time) {
                    timeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                    cell.isSelected = true
            }
        }
        return cell
    }

}

extension EditTimeAvailabilityViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dayCollectionView {
            selectedDay = Time.daysAbbrev[indexPath.item]
            guard let day = Time.daysDict[selectedDay] else { return }
            dayLabel.text = "Every \(day)"
            timeCollectionView.reloadData()
        } else if collectionView == timeCollectionView {
            let section = timeSections[indexPath.section]
            let item = section.items[indexPath.item]
            guard let time = item.getTime(), let dayIndex = Time.daysAbbrev.firstIndex(of: selectedDay) else { return }
            availabilities[dayIndex].append(time)
            dayCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == timeCollectionView {
            let section = timeSections[indexPath.section]
            let item = section.items[indexPath.item]

            guard let time = item.getTime(),
                  let dayIndex = Time.daysAbbrev.firstIndex(of: selectedDay) else {
                return
            }
            availabilities[dayIndex].removeAll { $0 == time }
            dayCollectionView.reloadData()
        }
    }

}

extension EditTimeAvailabilityViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dayCollectionView {
            return CGSize(width: 36, height: 48)
        }
        let itemCount = CGFloat(timeSections[indexPath.section].items.count)
        let itemWidth = timeCollectionView.frame.width / CGFloat(timeSections.count) - sectionInsets.left - sectionInsets.right
        let itemHeight = timeCollectionView.frame.height / itemCount - timeInteritemSpacing
        return CGSize(width: itemWidth, height: min(36, itemHeight))
    }

}
