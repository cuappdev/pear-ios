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
    private let finishButton = UIButton()
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
    private let finishButtonSize = CGSize(width: 175, height: 50)
    private let interitemSpacing: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    private let dayCellReuseId = "dayCellReuseIdentifier"
    private let timeCellReuseId = "timeCellReuseIdentifier"

    private var availabilities: [String: [String]] = [:]
    private let days = ["Su", "M", "Tu", "W", "Th", "F", "Sa"]
    private let daysDict = ["Su": "Sunday", "M": "Monday", "Tu": "Tuesday", "W": "Wednesday", "Th": "Thursday", "F": "Friday", "Sa": "Saturday"]
    private var selectedDay: String = "Su"

    private var afternoonItems: [ItemType] = []
    private let afternoonTimes = ["1:00", "1:30", "2:00", "2:30", "3:00", "3:30", "4:00", "4:30"]
    private var eveningItems: [ItemType] = []
    private let eveningTimes = ["5:00", "5:30", "6:00", "6:30", "7:00", "7:30", "8:00", "8:30"]
    private var morningItems: [ItemType] = []
    private let morningTimes = ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true

        morningItems = [ItemType.header("Morning")] + morningTimes.map { ItemType.time($0) }
        afternoonItems = [ItemType.header("Afternoon")] + afternoonTimes.map { ItemType.time($0) }
        eveningItems = [ItemType.header("Evening")] + eveningTimes.map { ItemType.time($0) }

        backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        titleLabel.text = "When are you free?"
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

        dayLabel.text  = "Every \(daysDict[selectedDay] ?? "")"
        dayLabel.textColor = .textBlack
        dayLabel.font = ._20CircularStdBook
        view.addSubview(dayLabel)

        let timeCollectionViewLayout = UICollectionViewFlowLayout()
        timeCollectionViewLayout.minimumInteritemSpacing = interitemSpacing
        timeCollectionViewLayout.sectionInset = sectionInsets
        timeCollectionViewLayout.scrollDirection = .horizontal

        timeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timeCollectionViewLayout)
        timeCollectionView.allowsMultipleSelection = true
        timeCollectionView.backgroundColor = .clear
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.register(SchedulingTimeCollectionViewCell.self, forCellWithReuseIdentifier: timeCellReuseId)
        view.addSubview(timeCollectionView)

        finishButton.setTitle("Finish", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.titleLabel?.font = ._20CircularStdBold
        finishButton.backgroundColor = .inactiveGreen
        finishButton.isEnabled = false
        finishButton.layer.cornerRadius = finishButtonSize.height / 2
        finishButton.addTarget(self, action: #selector(finishButtonPressed), for: .touchUpInside)
        view.addSubview(finishButton)

        setupConstraints()
        setupTimeSections()
    }

    private func setupTimeSections() {
        let afternoonSection = Section(type: .afternoon, items: afternoonItems)
        let eveningSection = Section(type: .evening, items: eveningItems)
        let morningSection = Section(type: .morning, items: morningItems)

        timeSections = [morningSection, afternoonSection, eveningSection]
    }

    private func setupConstraints() {
        let backButtonPadding = LayoutHelper.shared.getCustomHorizontalPadding(size: 30)
        let bottomPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 30)
        let titleLabelPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 50)

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
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(315)
        }

        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        timeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(16)
            make.bottom.equalTo(finishButton.snp.top).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(315)
        }

        finishButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-bottomPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(finishButtonSize)
        }
    }

    private func updateFinishButton() {
        let timeCount = availabilities.map({ $0.value.count }).reduce(0, +)
        finishButton.isEnabled = availabilities.count != 0 && timeCount > 0
        if finishButton.isEnabled {
            finishButton.backgroundColor = .backgroundOrange
            finishButton.layer.shadowColor = UIColor.black.cgColor
            finishButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            finishButton.layer.shadowOpacity = 0.15
            finishButton.layer.shadowRadius = 2
        } else {
            finishButton.backgroundColor = .inactiveGreen
            finishButton.layer.shadowColor = .none
            finishButton.layer.shadowOffset = .zero
            finishButton.layer.shadowOpacity = 0
            finishButton.layer.shadowRadius = 0
        }
    }

    @objc private func finishButtonPressed() {
        let placesVC = SchedulingPlacesViewController()
        navigationController?.pushViewController(placesVC, animated: false)
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: false)
    }

}

extension SchedulingTimeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionView == dayCollectionView ? 1 : timeSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == dayCollectionView ? days.count : timeSections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dayCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dayCellReuseId, for: indexPath) as? SchedulingDayCollectionViewCell else { return UICollectionViewCell() }
            let day = days[indexPath.item]
            cell.configure(for: day)
            // Update cell color based on whether there's availability for a day
            if let day = daysDict[day] {
                cell.updateBackgroundColor(isAvailable: availabilities[day] != nil)
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
                // Select times that were previously selected for a day
                if let day = daysDict[selectedDay],
                    let dayAvailability = availabilities[day],
                    dayAvailability.contains(time) {
                    timeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                    cell.isSelected = true
                }
            }
            return cell
        }
    }

}

extension SchedulingTimeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dayCollectionView {
            selectedDay = days[indexPath.item]
            dayLabel.text  = "Every \(daysDict[selectedDay] ?? "")"
            timeCollectionView.reloadData()
        } else {
            let section = timeSections[indexPath.section]
            let item = section.items[indexPath.item]
            guard let time = item.getTime(), let day = daysDict[selectedDay] else { return }
            if availabilities[day] == nil {
                availabilities[day] = [time]
            } else {
                availabilities[day]?.append(time)
            }
            dayCollectionView.reloadData()
            updateFinishButton()
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
            updateFinishButton()
        }
    }

}

extension SchedulingTimeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dayCollectionView {
            return CGSize(width: 36, height: 48)
        } else {
            let itemCount = CGFloat(timeSections[indexPath.section].items.count)
            let itemWidth = timeCollectionView.frame.width/3 - sectionInsets.left - sectionInsets.right
            let itemHeight = (timeCollectionView.frame.height)/itemCount - interitemSpacing
            return itemHeight > 36
                ? CGSize(width: itemWidth, height: 36)
                : CGSize(width: itemWidth, height: itemHeight)
        }
    }

}
