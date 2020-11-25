//
//  EditAvailabilitiesViewController.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/17/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

// MARK: - Default UICollectionView Header
private class DefaultHeader: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Location UICollectionView Header
private class LocationHeaderLabel: UICollectionReusableView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = ._16CircularStdBook
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with text: String) { label.text = text }

}

class EditAvailabilityViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let contentView = UIView(frame: .zero)
    private var dayCollectionView: UICollectionView!
    private let dayLabel = UILabel()
    private var editScrollView: UIScrollView!
    private var locationsCollectionView: UICollectionView!
    private let saveBarButtonItem = UIBarButtonItem()
    private let scheduleLocationLabel = UILabel()
    private let scheduleTimeLabel = UILabel()
    private let scheduleLocationSubLabel = UILabel()
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
    private let daysDict = [
        "Su": "Sunday",
        "M": "Monday",
        "Tu": "Tuesday",
        "W": "Wednesday",
        "Th": "Thursday",
        "F": "Friday",
        "Sa": "Saturday"
    ]
    private var selectedDay: String = "Su"

    // TODO: Change values after connecting to backend and get user's saved availabilities
    private var savedAvailabilities: [String: [String]] = [
        "Monday": ["5:30", "6:00", "6:30"],
        "Wednesday": ["10:30", "11:00", "11:30", "2:00", "2:30" ],
        "Friday": ["1:30", "2:00", "5:30", "6:00", "6:30"],
        "Saturday": ["7:30", "11:00", "11:30", "12:00", "12:30"]
    ]

    // MARK: - Location CollectionView Sections
    private enum LocationSection {
        case campus([String])
        case ctown([String])
    }

    // MARK: - Location Data Vars
    private let campusReuseId = "campusReuseIdentifier"
    private let campusHeaderId = "campusHeaderIdentifier"
    private let ctownReuseId = "ctownReuseIdentiifier"
    private let ctownHeaderId = "ctownHeaderIdentifier"
    private let defaultHeaderId = "defaultHeaderIdentifier"

    private var locationSections: [LocationSection] = []
    private var selectedCampusLocations: [String] = []
    private var selectedCtownLocations: [String] = []

    private let headerHeight: CGFloat = 50
    private let locationinteritemSpacing: CGFloat = 12
    private let locationLineSpacing: CGFloat = 12

    // TODO: Replace with networking when available
    private var campusLocations = [
        "Atrium Cafe",
        "Cafe Jennie",
        "Gimme Coffee",
        "Goldie's Cafe",
        "Green Dragon",
        "Libe Cafe",
        "Mac's Cafe",
        "Martha's Cafe",
        "Mattin's Cafe",
        "Temple of Zeus"
    ]
    private var ctownLocations = [
        "Kung Fu Tea",
        "Starbucks",
        "Mango Mango",
        "U Tea"
    ]

    private let savedLocations = [
        "Atrium Cafe",
        "Cafe Jennie",
        "Mango Mango"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        title = "Edit Availabilities"
        afternoonTimes = allAfternoonTimes
        eveningTimes = allEveningTimes
        morningTimes = allMorningTimes
        availabilities = savedAvailabilities
        setupNavigationBar()

        editScrollView = UIScrollView()
        editScrollView.backgroundColor = .clear
        editScrollView.layoutIfNeeded()
        editScrollView.showsVerticalScrollIndicator = false
        view.addSubview(editScrollView)

        editScrollView.addSubview(contentView)

        if let firstDay = daysDict[selectedDay] {
            setupTimes(for: firstDay, isFirstTime: true)
        }

        scheduleTimeLabel.font = ._20CircularStdBook
        scheduleTimeLabel.text = "When are you free?"
        scheduleTimeLabel.textColor = .black
        contentView.addSubview(scheduleTimeLabel)

        let dayCollectionViewLayout = UICollectionViewFlowLayout()
        dayCollectionViewLayout.minimumInteritemSpacing = timeInteritemSpacing
        dayCollectionViewLayout.scrollDirection = .horizontal

        dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: dayCollectionViewLayout)
        dayCollectionView.allowsSelection = true
        dayCollectionView.backgroundColor = .clear
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
        dayCollectionView.register(SchedulingDayCollectionViewCell.self, forCellWithReuseIdentifier: dayCellReuseId)
        dayCollectionView.register(DefaultHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: defaultHeaderId)
        dayCollectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(dayCollectionView)

        guard let day = daysDict[selectedDay] else { return }
        dayLabel.text = "Every \(day)"
        dayLabel.textColor = .black
        dayLabel.font = ._20CircularStdBook
        contentView.addSubview(dayLabel)

        let timeCollectionViewLayout = UICollectionViewFlowLayout()
        timeCollectionViewLayout.minimumInteritemSpacing = timeInteritemSpacing
        timeCollectionViewLayout.sectionInset = sectionInsets
        timeCollectionViewLayout.scrollDirection = .horizontal

        timeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timeCollectionViewLayout)
        timeCollectionView.allowsMultipleSelection = true
        timeCollectionView.backgroundColor = .clear
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.register(SchedulingTimeCollectionViewCell.self, forCellWithReuseIdentifier: timeCellReuseId)
        timeCollectionView.register(DefaultHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: defaultHeaderId)
        contentView.addSubview(timeCollectionView)

        scheduleLocationLabel.text = "Where do you prefer?"
        scheduleLocationLabel.font = ._20CircularStdBook
        scheduleLocationLabel.textColor = .black
        editScrollView.addSubview(scheduleLocationLabel)

        scheduleLocationSubLabel.text = "pick three"
        scheduleLocationSubLabel.font = ._16CircularStdBook
        scheduleLocationSubLabel.textColor = .greenGray
        contentView.addSubview(scheduleLocationSubLabel)

        let locationsCollectionViewLayout = UICollectionViewFlowLayout()
        locationsCollectionViewLayout.minimumLineSpacing = locationLineSpacing
        locationsCollectionViewLayout.minimumInteritemSpacing = locationinteritemSpacing

        locationsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: locationsCollectionViewLayout)
        locationsCollectionView.allowsMultipleSelection = true
        locationsCollectionView.showsVerticalScrollIndicator = false
        locationsCollectionView.showsHorizontalScrollIndicator = false
        locationsCollectionView.delegate = self
        locationsCollectionView.dataSource = self
        locationsCollectionView.backgroundColor = .clear
        locationsCollectionView.layer.masksToBounds = false
        locationsCollectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: campusReuseId)
        locationsCollectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: ctownReuseId)
        locationsCollectionView.register(LocationHeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: campusHeaderId)
        locationsCollectionView.register(LocationHeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ctownHeaderId)
        locationsCollectionView.isScrollEnabled = false
        contentView.addSubview(locationsCollectionView)

        selectedCampusLocations = campusLocations.filter {savedLocations.contains($0)}
        selectedCtownLocations = ctownLocations.filter {savedLocations.contains($0)}

        locationSections = [
            .campus(campusLocations),
            .ctown(ctownLocations)
        ]
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
        // TODO: save new availability
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
        let dayCollectionViewWidth = daysAbbrev.count * 45
        let collectionViewPadding = 30
        let collectionViewSidePadding = 32
        let numberofLocationRows = CGFloat(campusLocations.count/2).rounded() + CGFloat(ctownLocations.count/2).rounded()
        let scrollHeight = view.frame.height + (numberofLocationRows * 50)

        editScrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view)
        }

        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(editScrollView)
            make.height.equalTo(scrollHeight)
        }

        scheduleTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(editScrollView.snp.top).offset(20)
            make.centerX.equalTo(editScrollView.snp.centerX)
        }

        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleTimeLabel.snp.bottom).offset(20)
            make.centerX.equalTo(editScrollView.snp.centerX)
            make.height.equalTo(50)
            make.width.equalTo(dayCollectionViewWidth)
        }

        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(10)
            make.centerX.equalTo(editScrollView.snp.centerX)
        }

        timeCollectionView.snp.makeConstraints { make in
            let timeCollectionViewWidth = timeSections.count * 105
            let timeCollectionViewHeight = 400
            make.top.equalTo(dayLabel.snp.bottom).offset(20)
            make.height.equalTo(timeCollectionViewHeight)
            make.width.equalTo(timeCollectionViewWidth)
            make.centerX.equalTo(editScrollView.snp.centerX)
        }

        scheduleLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(timeCollectionView.snp.bottom).offset(55)
            make.centerX.equalTo(editScrollView.snp.centerX)
        }

        scheduleLocationSubLabel.snp.makeConstraints { make in
            make.top.equalTo(scheduleLocationLabel.snp.bottom).offset(5)
            make.centerX.equalTo(editScrollView.snp.centerX)
        }

        locationsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleLocationSubLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(collectionViewSidePadding)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).offset(-collectionViewPadding)
        }

    }

}

extension EditAvailabilityViewController: UICollectionViewDataSource {

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
        } else if collectionView == timeCollectionView {
            return timeSections[section].items.count
        }
        switch locationSections[section] {
        case .campus(let locations): return locations.count
        case .ctown(let locations): return locations.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dayCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dayCellReuseId, for: indexPath) as? SchedulingDayCollectionViewCell else { return UICollectionViewCell() }
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
        } else if collectionView == timeCollectionView {
            let section = timeSections[indexPath.section]
            let item = section.items[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeCellReuseId, for: indexPath) as? SchedulingTimeCollectionViewCell else { return  UICollectionViewCell() }
            switch item {
            case .header(let header):
                cell.configure(for: header, isHeader: true)
                cell.isUserInteractionEnabled = false
            case .time(let time):
                cell.configure(for: time, isHeader: false)
                cell.isUserInteractionEnabled = true
                if let day = daysDict[selectedDay] {
                    if let dayAvailability = availabilities[day], dayAvailability.contains(time) {
                        timeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                        cell.isSelected = true
                    }
                }
            }
            return cell
        } else {
            switch locationSections[indexPath.section] {
            case .campus(let locations):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: campusReuseId, for: indexPath) as? SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }
                let location = locations[indexPath.item]
                cell.configure(with: location, isPicking: false)
                if savedLocations.contains(location) {
                    cell.isSelected = true
                    locationsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                }
                return cell
            case .ctown(let locations):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ctownReuseId, for: indexPath) as? SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }
                let location = locations[indexPath.item]
                cell.configure(with: location, isPicking: false)
                if savedLocations.contains(location) {
                    cell.isSelected = true
                    locationsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                }
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == locationsCollectionView {
            if indexPath.section == 0 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: campusHeaderId, for: indexPath)
                guard let headerView = header as? LocationHeaderLabel else { return header }
                headerView.configure(with: "Campus")
                return headerView
            }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ctownHeaderId, for: indexPath)
            guard let headerView = header as? LocationHeaderLabel else { return header }
            headerView.configure(with: "Collegetown")
            return headerView
        }
        let defaultHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: defaultHeaderId, for: indexPath)
        guard let headerView = defaultHeader as? DefaultHeader else { return defaultHeader }
        return headerView
    }

}

extension EditAvailabilityViewController: UICollectionViewDelegate {

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
        } else if collectionView == locationsCollectionView {
            if selectedCampusLocations.count + selectedCtownLocations.count < 3 {
                let section = locationSections[indexPath.section]
                switch section {
                case .campus(let locations):
                    let location = locations[indexPath.row]
                    if !selectedCampusLocations.contains(location) {
                        selectedCampusLocations.append(location)
                    }
                case .ctown(let locations):
                    let location = locations[indexPath.row]
                    if !selectedCtownLocations.contains(location) {
                        selectedCtownLocations.append(location)
                    }
                }
                if let cell = collectionView.cellForItem(at: indexPath) as? SchedulingPlaceCollectionViewCell {
                    cell.isSelected = true
                }
            }
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
        } else if collectionView == locationsCollectionView {
            let section = locationSections[indexPath.section]
            switch section {
            case .campus(let locations):
                selectedCampusLocations.removeAll { $0 == locations[indexPath.row] }
            case .ctown(let locations):
                selectedCtownLocations.removeAll { $0 == locations[indexPath.row] }
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? SchedulingPlaceCollectionViewCell {
                cell.isSelected = false
            }
        }
    }
}

extension EditAvailabilityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dayCollectionView {
            return CGSize(width: 36, height: 48)
        } else if collectionView == timeCollectionView {
            let itemCount = CGFloat(timeSections[indexPath.section].items.count)
            let itemWidth = timeCollectionView.frame.width / CGFloat(timeSections.count) - sectionInsets.left - sectionInsets.right
            let itemHeight = timeCollectionView.frame.height / itemCount - timeInteritemSpacing
            return CGSize(width: itemWidth, height: min(36, itemHeight))
        } else {
            let numberColumns: CGFloat = 2
            let itemWidth = (locationsCollectionView.bounds.size.width - locationLineSpacing) / CGFloat(numberColumns)
            return CGSize(width: itemWidth, height: 42)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == locationsCollectionView {
            return CGSize(width: locationsCollectionView.bounds.size.width, height: headerHeight)

        }
        return CGSize(width: 0, height: 0)
    }
}

