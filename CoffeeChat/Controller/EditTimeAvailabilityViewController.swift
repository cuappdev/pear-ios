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

    // MARK: - Time CollectionView Sections
    private struct TimeSection {
        let type: SectionType
        var items: [ItemType]
    }

    private enum SectionType: String {
        case afternoon = "Afternoon"
        case evening = "Evening"
        case morning = "Morning"
    }

    private enum ItemType {
        case header(String)
        case time(String)

        func getTime() -> String? {
            switch self {
            case .time(let time):
                return time
            default:
                return nil
            }
        }
    }

    private var timeSections: [TimeSection] = []

    // MARK: - Time Data Vars
    private let timeInteritemSpacing: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    // All possible times available for parts of a day
    private var allAfternoonTimes = ["1:00", "1:30", "2:00", "2:30", "3:00", "3:30", "4:00", "4:30"]
    private var allEveningTimes = ["5:00", "5:30", "6:00", "6:30", "7:00", "7:30", "8:00", "8:30"]
    private var allMorningTimes = ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30"]

    // For times presented to user for parts of a day
    private var afternoonTimes: [String] = []
    private var eveningTimes: [String] = []
    private var morningTimes: [String] = []

    // For section items with a header and times
    private var afternoonItems: [ItemType] = []
    private var eveningItems: [ItemType] = []
    private var morningItems: [ItemType] = []

    private var availabilities: [String: [String]] = [:]
    private var daysAbbrev = ["Su", "M", "Tu", "W", "Th", "F", "Sa"]
    private let daysDict = ["Su": "Sunday", "M": "Monday", "Tu": "Tuesday", "W": "Wednesday", "Th": "Thursday", "F": "Friday", "Sa": "Saturday"]
    private var selectedDay: String = "Su"

    private var savedAvailabilities: [String: [String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        title = "Edit Availability"
        afternoonTimes = allAfternoonTimes
        eveningTimes = allEveningTimes
        morningTimes = allMorningTimes
        setupNavigationBar()
        getTimeAvailabilities()

        if let firstDay = daysDict[selectedDay] {
            setupTimes(for: firstDay, isFirstTime: true)
        }

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

        guard let day = daysDict[selectedDay] else { return }
        dayLabel.text = "Every \(day)"
        dayLabel.textColor = .black
        dayLabel.font = ._20CircularStdBook
        view.addSubview(dayLabel)

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

        setupTimeSections()
        setupConstraints()
    }

    private func setupNavigationBar() {
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
        var schedule: [DaySchedule] = []
        for (day, times) in availabilities {
            let floatTimes = times.map({Time.stringTimeToFloat(time: $0)})
            let daySchedule = DaySchedule(day: day.lowercased(), times: floatTimes)
            schedule.append(daySchedule)
        }
        NetworkManager.shared.updateTimeAvailabilities(savedAvailabilities: schedule).observe { response in
            switch response {
            case .value(let value):
                guard value.success else {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                    return
                }
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .error:
                self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
            }
        }
    }

    private func getTimeAvailabilities() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getUser(netId: netId).observe { response in
            switch response {
            case .value(let value):
                guard value.success else {
                    print("Network error: could not get time availabilities.")
                    return
                }
                var userAvailabilities: [String: [String]] = [:]
                for availability in value.data.availabilities {
                    userAvailabilities[availability.day.localizedCapitalized] = availability.times.map({Time.floatToStringTime(time: $0)})
                }
                self.savedAvailabilities = userAvailabilities
                DispatchQueue.main.async {
                    self.availabilities = self.savedAvailabilities
                    self.dayCollectionView.reloadData()
                    self.timeCollectionView.reloadData()
                }
            case .error:
                print("Network error: could not get time availabilities.")
            }
        }
    }

    private func setupTimes(for day: String, isFirstTime: Bool) {
        morningItems = [ItemType.header("Morning")] + morningTimes.map { ItemType.time($0) }
        afternoonItems = [ItemType.header("Afternoon")] + afternoonTimes.map { ItemType.time($0) }
        eveningItems = [ItemType.header("Evening")] + eveningTimes.map { ItemType.time($0) }
        if !isFirstTime {
            setupTimeSections()
        }
    }

    private func setupTimeSections() {
        let morningSection = TimeSection(type: .morning, items: morningItems)
        let afternoonSection = TimeSection(type: .afternoon, items: afternoonItems)
        let eveningSection = TimeSection(type: .morning, items: eveningItems)

        timeSections = [morningSection, afternoonSection, eveningSection]
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
            make.width.equalTo(daysAbbrev.count * 45)
        }

        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        timeCollectionView.snp.makeConstraints { make in
            let timeCollectionViewWidth = timeSections.count * 105
            let timeCollectionViewHeight = 400
            make.top.equalTo(dayLabel.snp.bottom).offset(20)
            make.height.equalTo(timeCollectionViewHeight)
            make.width.equalTo(timeCollectionViewWidth)
            make.centerX.equalToSuperview()
        }

    }

}

extension EditTimeAvailabilityViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == dayCollectionView {
            return 1
        } else if collectionView == timeCollectionView {
            return timeSections.count
        }
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dayCollectionView {
            return daysAbbrev.count
        }
        return timeSections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dayCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchedulingDayCollectionViewCell.reuseIdentifier, for: indexPath) as? SchedulingDayCollectionViewCell else { return UICollectionViewCell() }
            let day = daysAbbrev[indexPath.item]
            cell.configure(for: day)
            if let day = daysDict[day] {
                let isAvailable = availabilities[day] != nil
                cell.updateBackgroundColor(isAvailable: isAvailable)
            }
            if day == selectedDay {
                dayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                cell.isSelected = true
            }
            return cell
        }

        let section = timeSections[indexPath.section]
        let item = section.items[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchedulingTimeCollectionViewCell.reuseIdentifier, for: indexPath) as? SchedulingTimeCollectionViewCell else { return  UICollectionViewCell() }
        switch item {
        case .header(let header):
            cell.configure(for: header, isHeader: true)
            cell.isUserInteractionEnabled = false
        case .time(let time):
            cell.configure(for: time, isHeader: false)
            cell.isUserInteractionEnabled = true
            if let day = daysDict[selectedDay], let dayAvailability = availabilities[day], dayAvailability.contains(time) {
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
            selectedDay = daysAbbrev[indexPath.item]
            guard let day = daysDict[selectedDay] else { return }
            dayLabel.text = "Every \(day)"
            setupTimes(for: day, isFirstTime: false)
            timeCollectionView.reloadData()
        } else if collectionView == timeCollectionView {
            let section = timeSections[indexPath.section]
            let item = section.items[indexPath.item]
            guard let time = item.getTime(), let day = daysDict[selectedDay] else { return }
            if availabilities[day] == nil {
                availabilities[day] = [time]
            } else {
                availabilities[day]?.append(time)
            }
            dayCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == timeCollectionView {
            let section = timeSections[indexPath.section]
            let item = section.items[indexPath.item]
            guard let time = item.getTime(), let day = daysDict[selectedDay] else { return }
            availabilities[day]?.removeAll { $0 == time }
            if let dayAvailability = availabilities[day], dayAvailability.isEmpty {
                availabilities.removeValue(forKey: day)
            }
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
