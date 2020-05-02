//
//  SchedulingTimeViewController.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/19/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class SchedulingTimeViewController: UIViewController {

    // MARK: - Views
    private var backButton = UIButton()
    private var dayCollectionView: UICollectionView!
    private let dayLabel = UILabel()
    private let infoLabel = UILabel()
    private let nextButton = UIButton()
    private let noTimesWorkButton = UIButton()
    private var timeCollectionView: UICollectionView!
    private let titleLabel = UILabel()

    // MARK: - Section
    private struct Section {
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

    private var timeSections: [Section] = []

    // MARK: - Data
    private let nextButtonSize = CGSize(width: 175, height: 50)
    private let interitemSpacing: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    private let dayCellReuseId = "dayCellReuseIdentifier"
    private let timeCellReuseId = "timeCellReuseIdentifier"

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

    private var confirmedTime: (day: String, time: String)!
    // Whether user is confirming a time from match's availabilities
    private var isConfirmingTime: Bool
    // TODO: Remove after connecting to backend
    private var matchAvailabilities: [String: [String]] = ["Monday": ["5:30", "6:00", "6:30"], "Wednesday": ["10:30", "11:00", "11:30", "2:00", "2:30",], "Friday": ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "1:00", "1:30", "2:00", "5:30", "6:00", "6:30"], "Saturday": ["2:00", "2:30", "3:00", "3:30", "5:30", "6:00", "6:30", "7:00", "7:30", "11:00", "11:30", "12:00", "12:30"]]
    private let matchFirstName: String = "Ezra"

    init(isConfirmingTime: Bool) {
        self.isConfirmingTime = isConfirmingTime
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true

        afternoonTimes = allAfternoonTimes
        eveningTimes = allEveningTimes
        morningTimes = allMorningTimes

        if isConfirmingTime {
            daysAbbrev = daysAbbrev.filter { matchAvailabilities[daysDict[$0] ?? ""] != nil }
            if let firstDayShort = daysAbbrev.first {
                selectedDay = firstDayShort
            }
        }

        if let firstDay = daysDict[selectedDay] {
            setupTimes(for: firstDay, isFirstTime: true)
        }

        backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        titleLabel.text = isConfirmingTime ? "Pick a time to meet" : "When are you free?"
        titleLabel.textColor = .textBlack
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        let dayCollectionViewLayout = UICollectionViewFlowLayout()
        dayCollectionViewLayout.minimumInteritemSpacing = 4
        dayCollectionViewLayout.scrollDirection = .horizontal

        dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: dayCollectionViewLayout)
        dayCollectionView.allowsSelection = true
        dayCollectionView.backgroundColor = .clear
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
        dayCollectionView.register(SchedulingDayCollectionViewCell.self, forCellWithReuseIdentifier: dayCellReuseId)
        dayCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(dayCollectionView)

        dayLabel.text = isConfirmingTime ? daysDict[selectedDay] ?? "" : "Every \(daysDict[selectedDay] ?? "")"
        dayLabel.textColor = .textBlack
        dayLabel.font = ._20CircularStdBook
        view.addSubview(dayLabel)

        infoLabel.font = ._16CircularStdMedium
        infoLabel.text = "Here's when \(matchFirstName) is free"
        infoLabel.textAlignment = .center
        infoLabel.textColor = .greenGray
        view.addSubview(infoLabel)

        let timeCollectionViewLayout = UICollectionViewFlowLayout()
        timeCollectionViewLayout.minimumInteritemSpacing = interitemSpacing
        timeCollectionViewLayout.sectionInset = sectionInsets
        timeCollectionViewLayout.scrollDirection = .horizontal

        timeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timeCollectionViewLayout)
        timeCollectionView.allowsMultipleSelection = !isConfirmingTime
        timeCollectionView.backgroundColor = .clear
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.register(SchedulingTimeCollectionViewCell.self, forCellWithReuseIdentifier: timeCellReuseId)
        view.addSubview(timeCollectionView)

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.isEnabled = false
        nextButton.layer.cornerRadius = nextButtonSize.height / 2
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)
        
        noTimesWorkButton.setTitle("No times work", for: .normal)
        noTimesWorkButton.setTitleColor(.darkGreen, for: .normal)
        noTimesWorkButton.titleLabel?.font = ._16CircularStdMedium
        noTimesWorkButton.addTarget(self, action: #selector(noTimesWorkPressed), for: .touchUpInside)
        view.addSubview(noTimesWorkButton)

        setupTimeSections()
        setupConstraints()
    }

    func setupTimes(for day: String, isFirstTime: Bool) {
        if isConfirmingTime, let times = matchAvailabilities[day] {
            afternoonTimes = allAfternoonTimes.filter { times.contains($0) }
            eveningTimes = allEveningTimes.filter { times.contains($0) }
            morningTimes = allMorningTimes.filter { times.contains($0) }
        }
        morningItems = [ItemType.header("Morning")] + morningTimes.map { ItemType.time($0) }
        afternoonItems = [ItemType.header("Afternoon")] + afternoonTimes.map { ItemType.time($0) }
        eveningItems = [ItemType.header("Evening")] + eveningTimes.map { ItemType.time($0) }
        // Reset timeSections and timeCollectionView's constraints if it's not the first time `setupTimes` is called
        if !isFirstTime {
            setupTimeSections()
            setupTimeCollectionViewConstraints()
        }
    }

    private func setupTimeSections() {
        let afternoonSection = Section(type: .afternoon, items: afternoonItems)
        let eveningSection = Section(type: .evening, items: eveningItems)
        let morningSection = Section(type: .morning, items: morningItems)
        
        timeSections = []
        if !morningTimes.isEmpty {
            timeSections.append(morningSection)
        }
        if !afternoonTimes.isEmpty {
            timeSections.append(afternoonSection)
        }
        if !eveningTimes.isEmpty {
            timeSections.append(eveningSection)
        }
    }

    private func setupConstraints() {
        let backButtonPadding = LayoutHelper.shared.getCustomHorizontalPadding(size: 30)
        let bottomPadding = LayoutHelper.shared.getCustomVerticalPadding(size: isConfirmingTime ? 60 : 30)
        let titleLabelPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 50)
        let dayCollectionViewWidth = daysAbbrev.count * 45

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().inset(backButtonPadding)
            make.width.equalTo(14)
            make.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleLabelPadding)
            make.centerX.equalToSuperview()
        }

        dayCollectionView.snp.makeConstraints { make in
            if isConfirmingTime {
                make.top.equalTo(infoLabel.snp.bottom).offset(15)
            } else {
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
            }
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(dayCollectionViewWidth)
        }

        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(nextButtonSize)
        }
        
        if isConfirmingTime {
            infoLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(20)
            }
            
            noTimesWorkButton.snp.makeConstraints { make in
                make.top.equalTo(nextButton.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(20)
            }
        }
        
        setupTimeCollectionViewConstraints()
    }
    
    private func setupTimeCollectionViewConstraints() {
        let timeCollectionViewWidth = timeSections.count * 105
        
        timeCollectionView.snp.updateConstraints { update in
            update.top.equalTo(dayLabel.snp.bottom).offset(8)
            update.bottom.equalTo(nextButton.snp.top).offset(-20)
            update.centerX.equalToSuperview()
            update.width.equalTo(timeCollectionViewWidth)
        }
    }

    private func updateNextButton() {
        let timeCount = availabilities.map({ $0.value.count }).reduce(0, +)
        nextButton.isEnabled = !availabilities.isEmpty && timeCount > 0 || confirmedTime != nil
        if nextButton.isEnabled {
            nextButton.backgroundColor = .backgroundOrange
            nextButton.layer.shadowColor = UIColor.black.cgColor
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            nextButton.layer.shadowOpacity = 0.15
            nextButton.layer.shadowRadius = 2
        } else {
            nextButton.backgroundColor = .inactiveGreen
            nextButton.layer.shadowColor = .none
            nextButton.layer.shadowOffset = .zero
            nextButton.layer.shadowOpacity = 0
            nextButton.layer.shadowRadius = 0
        }
    }

    @objc private func nextButtonPressed() {
        let placesVC = SchedulingPlacesViewController(isConfirmingTime: isConfirmingTime, availabilities: availabilities, confirmedTime: confirmedTime)
        navigationController?.pushViewController(placesVC, animated: false)
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: false)
    }

    @objc private func noTimesWorkPressed() {
        // TODO: Show alert asking for confirmation
    }

}

extension SchedulingTimeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionView == dayCollectionView ? 1 : timeSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == dayCollectionView ? daysAbbrev.count : timeSections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dayCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dayCellReuseId, for: indexPath) as? SchedulingDayCollectionViewCell else { return UICollectionViewCell() }
            let day = daysAbbrev[indexPath.item]
            cell.configure(for: day)
            // Update cell color based on whether there's availability for a day
            if let day = daysDict[day], confirmedTime != nil {
                let isAvailable = isConfirmingTime ? confirmedTime.day == day : availabilities[day] != nil
                cell.updateBackgroundColor(isAvailable: isAvailable)
            }
            // Select item if day is the selected day
            if day == selectedDay {
                dayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                cell.isSelected = true
            }
            return cell
        } else {
            let section = timeSections[indexPath.section]
            let item = section.items[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeCellReuseId, for: indexPath) as? SchedulingTimeCollectionViewCell else { return UICollectionViewCell() }
            switch item {
            case .header(let header):
                cell.configure(for: header, isHeader: true)
                cell.isUserInteractionEnabled = false
            case .time(let time):
                cell.configure(for: time, isHeader: false)
                cell.isUserInteractionEnabled = true
                // Select time(s) that was previously selected for a day
                if let day = daysDict[selectedDay] {
                    if isConfirmingTime,
                        confirmedTime != nil && confirmedTime.time == time && confirmedTime.day == day {
                        timeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                        cell.isSelected = true
                    } else if let dayAvailability = availabilities[day],
                        dayAvailability.contains(time) {
                        timeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                        cell.isSelected = true
                    }
                }
            }
            return cell
        }
    }

}

extension SchedulingTimeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dayCollectionView {
            selectedDay = daysAbbrev[indexPath.item]
            dayLabel.text  = isConfirmingTime ? daysDict[selectedDay] ?? "" : "Every \(daysDict[selectedDay] ?? "")"
            if isConfirmingTime, let day = daysDict[selectedDay] {
                setupTimes(for: day, isFirstTime: false)
            }
            timeCollectionView.reloadData()
        } else {
            let section = timeSections[indexPath.section]
            let item = section.items[indexPath.item]
            guard let time = item.getTime(), let day = daysDict[selectedDay] else { return }
            if isConfirmingTime {
                confirmedTime = (day: day, time: time)
            } else {
                if availabilities[day] == nil {
                    availabilities[day] = [time]
                } else {
                    availabilities[day]?.append(time)
                }
            }
            dayCollectionView.reloadData()
            updateNextButton()
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
            updateNextButton()
        }
    }

}

extension SchedulingTimeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dayCollectionView {
            return CGSize(width: 36, height: 48)
        } else {
            let itemCount = CGFloat(timeSections[indexPath.section].items.count)
            let itemWidth = timeCollectionView.frame.width / CGFloat(timeSections.count) - sectionInsets.left - sectionInsets.right
            let itemHeight = timeCollectionView.frame.height / itemCount - interitemSpacing
            return CGSize(width: itemWidth, height: min(36, itemHeight))
        }
    }

}
