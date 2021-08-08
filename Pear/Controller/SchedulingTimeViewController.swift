//
//  SchedulingTimeViewController.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/19/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//
import UIKit

// MARK: - SchedulingStatus

/// The context in which the user is picking times
enum SchedulingStatus {
    /// If the user has no pear, they can input their typical availabilities
    case pickingTypical
    /// If the user reaches out first, they confirm all of their availabilities
    case confirming
    /// If the pear reached out first, the user chooses 1 time from the availabilities
    case choosing
}

// MARK: - SelectedSchedules

/**
 Handles the logic of selection for when the user has to pick one or multiple times
 Also handles converting selected time strings and days to `DaySchedule`
*/
fileprivate class SelectedSchedules {

    /// User either picks multiple times in some cases, and just toggles a singular time
    private enum SelectedItem {
        case multiple([DaySchedule])
        case single(DaySchedule?)
    }
    private var selectedItem: SelectedItem

    /// Array of all selected schedules. Is an array of 0 or 1 elements if choosing
    var schedules: [DaySchedule] {
        switch selectedItem {
        case .multiple(let schedules):
            return schedules
        case .single(let schedule):
            if let schedule = schedule {
                return [schedule]
            } else {
                return []
            }
        }
    }

    var numberSelected: Int {
        switch selectedItem {
        case .multiple(let schedules):
            return schedules.count
        case .single(let schedule):
            return schedule == nil ? 0 : 1
        }
    }

    init(availabilities: [DaySchedule]) {
        selectedItem = .multiple(availabilities)
    }

    init() {
        selectedItem = .single(nil)
    }

    func add(day: String, time: String) {
        let time = Time.stringTimeToFloat(time: time)
        let newSelection: SelectedItem

        switch selectedItem {
        case .multiple(var schedules):
            if let daySchedule = schedules.first(where: { $0.day == day }) {
                daySchedule.times.append(time)
            } else {
                schedules.append(DaySchedule(day: day, times: [time]))
            }
            newSelection = .multiple(schedules)
        case .single:
            newSelection = .single(DaySchedule(day: day, times: [time]))
        }

        selectedItem = newSelection
    }

    func remove(day: String, time: String) {
        let time = Time.stringTimeToFloat(time: time)
        let newSelection: SelectedItem

        switch selectedItem {
        case .multiple(var schedules):
            if let daySchedule = schedules.first(where: { $0.day == day }) {
                daySchedule.times.removeAll { $0 == time }
                if daySchedule.times.isEmpty {
                    schedules.removeAll { $0.day == daySchedule.day }
                }
            }
            newSelection = .multiple(schedules)
        case .single:
            newSelection = .single(nil)
        }

        selectedItem = newSelection
    }

}

// MARK: - Section
struct TimeSection {
    let type: SectionType
    var items: [ItemType]
}

enum SectionType: String {
    case afternoon = "Afternoon"
    case evening = "Evening"
    case morning = "Morning"
}

enum ItemType {
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

class SchedulingTimeViewController: UIViewController {

    // MARK: - Views
    private var backButton = UIButton()
    private var dayCollectionView: UICollectionView!
    private let dayLabel = UILabel()
    private let infoLabel = UILabel()
    private let nextButton = UIButton()
    private let noTimesWorkButton = UIButton()
    private var timeCollectionView: UICollectionView!
    private var timeScrollView: FadeWrapperView<UIScrollView>!
    private let titleLabel = UILabel()
    private let timezoneLabel = UILabel()
    
    private var errorMessageAlertView: MessageAlertView!
    private var errorMessageVisualEffectView: UIVisualEffectView!
    
    private var emailMessageAlertView: MessageAlertView!
    private var emailMessageVisualEffectView: UIVisualEffectView!
    

    // MARK: - Sizing
    private let timeCellSize = CGSize(width: LayoutHelper.shared.getCustomHorizontalPadding(size: 88), height: 36)
    private let timeCellVerticalSpacing: CGFloat = 8
    private var timeCollectionViewWidth: CGFloat {
        CGFloat(CGFloat(timeSections.count) * LayoutHelper.shared.getCustomHorizontalPadding(size: 105))
    }
    private let nextButtonSize = CGSize(width: 175, height: 50)
    private let interitemSpacing: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    private var timeSections: [TimeSection] = []

    // MARK: Time Related
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

    // Handling Abbreviations
    private var daysAbbrev = ["Su", "M", "Tu", "W", "Th", "F", "Sa"]
    private let abbrevToDayDict = [
      "Su": Constants.Match.sunday,
      "M": Constants.Match.monday,
      "Tu": Constants.Match.tuesday,
      "W": Constants.Match.wednesday,
      "Th": Constants.Match.thursday,
      "F": Constants.Match.friday,
      "Sa": Constants.Match.saturday
    ]
    private var selectedDayAbbrev: String = "Su"

    // Availabilities Selected
    private var selectedTimes: SelectedSchedules?

    // MARK: ViewController State
    private let user: User
    private let pair: User?
    private var match: Match?
    private var schedulingStatus: SchedulingStatus

    private var isChoosing: Bool { .choosing ~= schedulingStatus }
    private var isConfirming: Bool { .confirming ~= schedulingStatus }

    convenience init(for status: SchedulingStatus, user: User, pair: User, match: Match) {
        self.init(status: status, user: user, pair: pair, match: match)
    }

    convenience init(for status: SchedulingStatus, user: User) {
        self.init(status: status, user: user)
    }

    private init(status: SchedulingStatus, user: User, pair: User? = nil, match: Match? = nil) {
        self.schedulingStatus = status
        self.match = match
        self.user = user
        self.pair = pair
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getAvailabilitiesLeftForMatch(availabilities: [DaySchedule]) -> [DaySchedule] {
        var daysLeftForMatch = [
          Constants.Match.sunday,
          Constants.Match.monday,
          Constants.Match.tuesday,
          Constants.Match.wednesday,
          Constants.Match.thursday,
          Constants.Match.friday,
          Constants.Match.saturday
        ]
        let dayIndex = Calendar.current.component(.weekday, from: Date()) - 1
        daysLeftForMatch.removeSubrange(0..<dayIndex)
        return availabilities.filter { daysLeftForMatch.contains($0.day) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen

        getSelectedTimes()
        setupViews()
        setupDaysAndTimes()
        setupForStatus()
        
        setupTimeSections()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Setup
    private func setupDaysAndTimes() {
        afternoonTimes = allAfternoonTimes
        eveningTimes = allEveningTimes
        morningTimes = allMorningTimes

        if isConfirming || isChoosing {
            removePassedDaysFromDisplay()
        }

        if isChoosing {
            removeUnavailableDaysFromDisplay()
        }

        guard let firstDay = daysAbbrev.first else {
            fatalError("At least one day must be available to select, but daysAbbrev was empty; have all available times passed or did the pear not have any available times?")
        }
        selectedDayAbbrev = firstDay
        changeDisplayedTimes(for: abbrevToDayDict[firstDay] ?? "Sunday")
    }

    private func getSelectedTimes() {
        getUserAvailabilitiesThen { [weak self] userAvailabilities in
            guard let self = self else { return }
            switch self.schedulingStatus {
            case .confirming:
                let availabilitiesLeftForMatch = self.getAvailabilitiesLeftForMatch(availabilities: userAvailabilities)
                self.selectedTimes = SelectedSchedules(availabilities: availabilitiesLeftForMatch)
            case .choosing:
                self.selectedTimes = SelectedSchedules(availabilities: [])
            default:
                self.selectedTimes = SelectedSchedules(availabilities: userAvailabilities)
            }
            self.dayCollectionView.reloadData()
            self.timeCollectionView.reloadData()
            self.updateNextButton()
        }
    }

    private func getUserAvailabilitiesThen(_ completion: @escaping ([DaySchedule]) -> Void) {
        NetworkManager.shared.getUserAvailabilities(netId: user.netID).observe { response in
            DispatchQueue.main.async {
                switch response {
                case .value(let result):
                    guard result.success else {
                        print("Network error: could not get user's availabilities.")
                        return
                    }
                    completion(result.data)
                case .error:
                    print("Network error: could not get user's availabilities.")
                }
            }
        }
    }

    private func setupForStatus() {
        let dayString = abbrevToDayDict[selectedDayAbbrev]?.withCapitalizedFirstLetter ?? ""
        switch schedulingStatus {
        case .pickingTypical:
            titleLabel.text = "When are you free?"
            dayLabel.text = "Every \(dayString)"
        case .confirming:
            titleLabel.text = "Confirm your availability"
            dayLabel.text = dayString
        case .choosing:
            titleLabel.text = "Pick a time to meet"
            dayLabel.text = dayString
        }
       
        timeCollectionView.allowsMultipleSelection = !isChoosing
    }

    private func setupViews() {
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        titleLabel.textColor = .black
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
        dayCollectionView.register(SchedulingDayCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingDayCollectionViewCell.reuseIdentifier)
        dayCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(dayCollectionView)

        dayLabel.textColor = .black
        dayLabel.font = ._20CircularStdBook
        view.addSubview(dayLabel)

        timezoneLabel.text = "All times are in eastern time"
        timezoneLabel.textColor = .greenGray
        timezoneLabel.font = ._16CircularStdBook
        view.addSubview(timezoneLabel)

        infoLabel.font = ._16CircularStdMedium
        infoLabel.text = "Here's when \(pair?.firstName ?? "") is free"
        infoLabel.textAlignment = .center
        infoLabel.textColor = .greenGray
        view.addSubview(infoLabel)

        let timeCollectionViewLayout = UICollectionViewFlowLayout()
        timeCollectionViewLayout.minimumInteritemSpacing = interitemSpacing
        timeCollectionViewLayout.sectionInset = sectionInsets
        timeCollectionViewLayout.scrollDirection = .horizontal

        timeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timeCollectionViewLayout)
        timeCollectionView.backgroundColor = .clear
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.clipsToBounds = false
        timeCollectionView.register(SchedulingTimeCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingTimeCollectionViewCell.reuseIdentifier)
        timeCollectionView.isScrollEnabled = false

        timeScrollView = FadeWrapperView(UIScrollView(), fadeColor: .backgroundLightGreen)
        timeScrollView.fadePositions = [.top, .bottom]
        timeScrollView.view.addSubview(timeCollectionView)
        timeScrollView.view.isScrollEnabled = true
        timeScrollView.view.delegate = self
        timeScrollView.view.contentInset = UIEdgeInsets(top: timeScrollView.fadeInsets.top, left: 0, bottom: timeScrollView.fadeInsets.bottom, right: 0)
        view.addSubview(timeScrollView)

        let nextButtonText = schedulingStatus == .pickingTypical ? "Save" : "Next"
        nextButton.setTitle(nextButtonText, for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = nextButtonSize.height / 2
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        noTimesWorkButton.setTitle("No times work", for: .normal)
        noTimesWorkButton.setTitleColor(.darkGreen, for: .normal)
        noTimesWorkButton.titleLabel?.font = ._16CircularStdMedium
        noTimesWorkButton.addTarget(self, action: #selector(noTimesWorkPressed), for: .touchUpInside)
        view.addSubview(noTimesWorkButton)
    }

    private func setupTimeSections() {
        let afternoonSection = TimeSection(type: .afternoon, items: afternoonItems)
        let eveningSection = TimeSection(type: .evening, items: eveningItems)
        let morningSection = TimeSection(type: .morning, items: morningItems)

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
        let bottomPadding = LayoutHelper.shared.getCustomVerticalPadding(size: isChoosing ? 60 : 30)
        let titleLabelPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 50)
        let dayCollectionViewWidth = daysAbbrev.count * 45

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().inset(backButtonPadding)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleLabelPadding)
            make.centerX.equalToSuperview()
        }

        dayCollectionView.snp.makeConstraints { make in
            if isChoosing {
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

        timezoneLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(nextButtonSize)
        }

        if isChoosing {
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
        timeScrollView.snp.updateConstraints { update in
            update.top.equalTo(timezoneLabel.snp.bottom).offset(8)
            update.bottom.equalTo(nextButton.snp.top).offset(-20)
            update.centerX.equalToSuperview()
            update.width.equalTo(timeCollectionViewWidth)
        }

        timeScrollView.view.contentSize = calculateTimesHeight()

        timeCollectionView.snp.remakeConstraints { remake in
            remake.top.equalTo(timeScrollView.view.snp.top)
            remake.size.equalTo(timeScrollView.view.contentSize)
        }

    }

    private func calculateTimesHeight() -> CGSize {
        // +1 is due to the header
        let longestTimeCount = CGFloat(max(morningTimes.count, afternoonTimes.count, eveningTimes.count)) + 1
        let cellsHeight = timeCellSize.height * longestTimeCount
        let interitemHeight = timeCellVerticalSpacing * (longestTimeCount - 1)
        return CGSize(width: timeCollectionViewWidth, height: cellsHeight + interitemHeight)
    }

    // MARK: - Time Related
    private func changeDisplayedTimes(for day: String) {
        if isChoosing {
            let timeStrings: [String]

            if let scheduleForDay = match?.availabilities.first(where: { $0.day == day }) {
                timeStrings = scheduleForDay.times.map { Time.floatToStringTime(time: $0) }
            } else {
                timeStrings = []
            }

            afternoonTimes = allAfternoonTimes.filter { timeStrings.contains($0) }
            eveningTimes = allEveningTimes.filter { timeStrings.contains($0) }
            morningTimes = allMorningTimes.filter { timeStrings.contains($0) }
        }

        morningItems = [ItemType.header("Morning")] + morningTimes.map { ItemType.time($0) }
        afternoonItems = [ItemType.header("Afternoon")] + afternoonTimes.map { ItemType.time($0) }
        eveningItems = [ItemType.header("Evening")] + eveningTimes.map { ItemType.time($0) }

        setupTimeSections()
        setupTimeCollectionViewConstraints()
    }

    private func removePassedDaysFromDisplay() {
        daysAbbrev = ["Su", "M", "Tu", "W", "Th", "F", "Sa"]
        let dayIndex = Calendar.current.component(.weekday, from: Date()) - 1
        daysAbbrev.removeSubrange(0..<dayIndex)
    }

    private func removeUnavailableDaysFromDisplay() {
        daysAbbrev = daysAbbrev.filter {
            let day = abbrevToDayDict[$0] ?? ""
            if let availability = match?.availabilities.first(where: { $0.day == day }) {
                return !availability.times.isEmpty
            } else {
                return false
            }
        }
    }

    private func showErrorMessageAlertView() {
        errorMessageAlertView = MessageAlertView(
            mainMessage: Constants.Alerts.NoTimesWork.message,
            actionMessage: Constants.Alerts.NoTimesWork.action,
            dismissMessage: Constants.Alerts.NoTimesWork.dismiss,
            alertImageName: "sadPear",
            removeFunction: { dismiss in
                if dismiss {
                    self.cancelMatchAndPopViewController()
                }
                UIView.animate(withDuration: 0.15, animations: {
                    self.errorMessageVisualEffectView.alpha = 0
                    self.errorMessageAlertView.alpha = 0
                    self.errorMessageAlertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }, completion: { _ in
                    self.errorMessageAlertView.removeFromSuperview()
                    self.errorMessageVisualEffectView.removeFromSuperview()
                })
            }
        )
        let blurEffect = UIBlurEffect(style: .light)
        errorMessageVisualEffectView = UIVisualEffectView(effect: blurEffect)
        
        errorMessageVisualEffectView.frame = view.bounds
        view.addSubview(errorMessageVisualEffectView)
        view.addSubview(errorMessageAlertView)

        errorMessageAlertView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(281)
            make.width.equalTo(292)
        }

        UIView.animate(withDuration: 0.25, animations: {
            self.errorMessageAlertView.transform = .init(scaleX: 1.5, y: 1.5)
            self.errorMessageVisualEffectView.alpha = 1
            self.errorMessageAlertView.alpha = 1
            self.errorMessageAlertView.transform = .identity
        })
    }
    
    private func showEmailMessageAlertView() {
        
        emailMessageAlertView = MessageAlertView(
            mainMessage: "Send your Pear a personal note.",
            actionMessage: "Send an email",
            dismissMessage: "Skip",
            alertImageName: "happyPear",
            removeFunction: { [weak self] dismiss in
                guard let self = self else { return }
                guard let match = self.match else { return }
                if !dismiss {
                    let emailAlertController = UIAlertController.getEmailAlertController(
                        email: "\(match.pair ?? "")@cornell.edu",
                        subject: "Hello from your pear!"
                    )
                    self.present(emailAlertController, animated: true)
                }
                self.updateMatchAvailabilities()
                UIView.animate(withDuration: 0.15, animations: {
                    self.emailMessageVisualEffectView.alpha = 0
                    self.emailMessageAlertView.alpha = 0
                    self.emailMessageAlertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }, completion: { _ in
                    self.emailMessageAlertView.removeFromSuperview()
                    self.emailMessageVisualEffectView.removeFromSuperview()
                })
            }
        )
        
        let blurEffect = UIBlurEffect(style: .light)
        emailMessageVisualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(emailMessageVisualEffectView)
        
        emailMessageVisualEffectView.frame = view.bounds
        view.addSubview(emailMessageAlertView)

        emailMessageAlertView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(281)
            make.width.equalTo(292)
        }

        UIView.animate(withDuration: 0.25, animations: {
            self.emailMessageAlertView.transform = .init(scaleX: 1.5, y: 1.5)
            self.emailMessageVisualEffectView.alpha = 1
            self.emailMessageAlertView.alpha = 1
            self.emailMessageAlertView.transform = .identity
        })
    }
    
    private func updateMatchAvailabilities() {
        match?.availabilities = selectedTimes?.schedules ?? []
        guard let match = match else { return }
        NetworkManager.shared.updateMatchAvailabilities(match: match).observe { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case .value(let value):
                    if value.success {
                        UserDefaults.standard.set(match.matchID, forKey: Constants.UserDefaults.matchIDLastReachedOut)
                            self.navigationController?.pushViewController(HomeViewController(), animated: true)
                    } else {
                        self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                    }
                case .error:
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                }
            }
        }
    }

    // MARK: - Button Related
    private func updateNextButton() {
        guard let selectedTimes = selectedTimes else { return }
        nextButton.isEnabled = selectedTimes.numberSelected > 0
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

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func noTimesWorkPressed() {
        showErrorMessageAlertView()
    }

    @objc private func nextButtonPressed() {
        switch schedulingStatus {
        case .choosing, .confirming:
            showEmailMessageAlertView()
        case .pickingTypical:
            updateUserAvailabilitiesAndPop()
        }
    }

    // MARK: - Navigation
    private func updateUserAvailabilitiesAndPop() {
        guard let selectedTimes = selectedTimes else { return }
        NetworkManager.shared.updateTimeAvailabilities(
            savedAvailabilities: selectedTimes.schedules
        ).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                    }
                case .error:
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
    }

    /* Places scheduling not currently supported on backend.

    private func continueToSchedulingPlaces() {

        guard let match = match else {
            print("Tried to continue to scheduling places view controller, but match is nil")
            navigationController?.popViewController(animated: true)
            return
        }

        let editedMatch = Match(
            matchID: match.matchID,
            status: match.status,
            meetingTime: match.meetingTime,
            users: match.users,
            availabilities: selectedTimes.schedules
        )

         let placesVC = SchedulingPlacesViewController(
            status: schedulingStatus,
            match: editedMatch
        )
        navigationController?.pushViewController(placesVC, animated: true)

    }

     */

}

// MARK: - UICollectionViewDataSource
extension SchedulingTimeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView == dayCollectionView ? 1 : timeSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == dayCollectionView ? daysAbbrev.count : timeSections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        if collectionView == dayCollectionView {
            return configuredDayCell(for: indexPath)
        } else {
            return configuredTimeCell(for: indexPath)
        }
    }

    private func configuredDayCell(for indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = dayCollectionView.dequeueReusableCell(
                withReuseIdentifier: SchedulingDayCollectionViewCell.reuseIdentifier,
                for: indexPath) as? SchedulingDayCollectionViewCell else {
            return UICollectionViewCell()
        }

        let dayAbbrev = daysAbbrev[indexPath.item]
        cell.configure(for: dayAbbrev)

        guard let selectedTimes = selectedTimes else { return cell }

        // Update cell color based on whether there's availability for a day
        if let day = abbrevToDayDict[dayAbbrev] {
            let availability = selectedTimes.schedules.first { $0.day == day }
            let isAvailable = (availability?.times.count ?? 0) > 0
            cell.updateBackgroundColor(isAvailable: isAvailable)
        }
        // Select item if day is the selected day
        if dayAbbrev == selectedDayAbbrev {
            dayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            cell.isSelected = true
        }
        return cell
    }

    private func configuredTimeCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = timeCollectionView.dequeueReusableCell(
                withReuseIdentifier: SchedulingTimeCollectionViewCell.reuseIdentifier,
                for: indexPath) as? SchedulingTimeCollectionViewCell else {
            return UICollectionViewCell()
        }

        let section = timeSections[indexPath.section]
        let item = section.items[indexPath.item]

        switch item {
        case .header(let header):
            cell.configure(for: header, isHeader: true)
            cell.isUserInteractionEnabled = false

        case .time(let timeString):
            cell.configure(for: timeString, isHeader: false)
            cell.isUserInteractionEnabled = true

            let time = Time.stringTimeToFloat(time: timeString)

            // Select time(s) that were previously selected for a day
            guard let day = abbrevToDayDict[selectedDayAbbrev],
                  let selectedTimes = selectedTimes else { return cell }

            if selectedTimes.schedules.contains(where: { $0.day == day && $0.times.contains(time) }) {
                timeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                cell.isSelected = true
            }
        }

        return cell
    }

}

// MARK: - UICollectionViewDelegate
extension SchedulingTimeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard collectionView == timeCollectionView, let cell = collectionView.cellForItem(at: indexPath) else { return true }
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            return true
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dayCollectionView {
            selectNewDay(indexPath: indexPath)
        } else {
            selectNewTime(indexPath: indexPath)
            dayCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView == timeCollectionView else { return }
        deselectNewTime(indexPath: indexPath)
    }

    private func selectNewDay(indexPath: IndexPath) {
        selectedDayAbbrev = daysAbbrev[indexPath.item]
        let dayString = abbrevToDayDict[selectedDayAbbrev] ?? ""
        dayLabel.text  = isChoosing
            ? dayString.withCapitalizedFirstLetter
            : "Every \(dayString.withCapitalizedFirstLetter)"

        if isChoosing {
            changeDisplayedTimes(for: dayString)
        }

        timeCollectionView.reloadData()
    }

    private func selectNewTime(indexPath: IndexPath) {
        let section = timeSections[indexPath.section]
        let item = section.items[indexPath.item]

        if schedulingStatus == .choosing {
            self.selectedTimes = SelectedSchedules(availabilities: [])
        }

        guard let time = item.getTime(),
              let day = abbrevToDayDict[selectedDayAbbrev],
              let selectedTimes = selectedTimes else { return }

        selectedTimes.add(day: day, time: time)

        updateNextButton()
    }

    private func deselectNewTime(indexPath: IndexPath) {
        let section = timeSections[indexPath.section]
        let item = section.items[indexPath.item]

        guard let time = item.getTime(),
              let day = abbrevToDayDict[selectedDayAbbrev],
              let selectedTimes = selectedTimes else { return }

        selectedTimes.remove(day: day, time: time)

        dayCollectionView.reloadData()
        updateNextButton()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension SchedulingTimeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dayCollectionView {
            return CGSize(width: 36, height: 48)
        } else {
            return timeCellSize
        }
    }

}

// MARK: - MessageAlertViewDelegate
extension SchedulingTimeViewController {

    private func cancelMatchAndPopViewController() {
        guard let match = match else { return }

        NetworkManager.shared.cancelMatch(matchID: match.matchID).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let value):
                    if value.success {
                        print("Succesfully cancelled matches")
                        self.navigationController?.pushViewController(HomeViewController(), animated: true)
                    } else {
                        print("Network error: could not cancel match.")
                    }
                case .error:
                    print("Network error: could not cancel match.")
                }
            }
        }
    }

}

// MARK: - String Extension
fileprivate extension String {

    var withCapitalizedFirstLetter: String {
        guard self.count >= 1 else { return "" }
        let first = self.prefix(1).uppercased()
        let last = self.dropFirst()
        return first + last
    }

}
