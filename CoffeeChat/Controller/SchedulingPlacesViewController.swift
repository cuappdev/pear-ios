//
//  SchedulingPlacesViewController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class SchedulingPlacesViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let infoLabel = UILabel()
    private var locationsCollectionView: UICollectionView!
    private let nextButton = UIButton()
    private let titleLabel = UILabel()

    // Reuse Identifiers
    private let campusHeaderIdentifier = "campusHeaderIdentifier"
    private let ctownHeaderIdentifier = "ctownHeaderIdentifier"

    // MARK: - Collection View Sections
    private enum Section {
        case campus([String])
        case ctown([String])
    }

    // MARK: - Data Vars
    private var locationSections: [Section] = []
    private var selectedCampusLocations: [String] = []
    private var selectedCtownLocations: [String] = []
    private var totalSelectedLocations: Int {
        selectedCampusLocations.count + selectedCtownLocations.count
    }

    private let schedulingStatus: SchedulingStatus
    private var isChoosing: Bool { .choosing ~= schedulingStatus }
    // Location user picked from match's locations
    private var pickedLocation: String?

    // Data received from `SchedulingTimeViewController`
    // private var availabilities: [SubTimeAvailability] = []
    private var match: Match
    private var pickedTime: (day: String, time: String) = (day: "", time: "")

    private let headerHeight: CGFloat = 50
    private let interitemSpacing: CGFloat = 12
    private let lineSpacing: CGFloat = 12

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
    // TODO replace once the match includes location information
    private let matchLocations: [String] = [
        "Atrium Cafe",
        "Cafe Jennie",
        "Gimme Coffee",
        "Goldie's Cafe",
        "Green Dragon",
        "Libe Cafe",
        "Mac's Cafe",
        "Martha's Cafe",
        "Mattin's Cafe",
        "Temple of Zeus",
        "Kung Fu Tea",
        "Starbucks",
        "Mango Mango",
        "U Tea"
    ]
    private let savedLocations: [String] = []

    init(status: SchedulingStatus, match: Match, pickedTime: (day: String, time: String)) {
        self.schedulingStatus = status
        self.pickedTime = pickedTime
        self.match = match
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen

        setupViews()
        setupLocationSections()
        setupForStatus()
        setupConstraints()
        updateNext()
    }

    // MARK: - Setup Functions
    private func setupLocationSections() {
        if isChoosing {
            campusLocations = campusLocations.filter(matchLocations.contains)
            ctownLocations = ctownLocations.filter(matchLocations.contains)
        }
        locationSections = [
            .campus(campusLocations),
            .ctown(ctownLocations)
        ]
    }

    private func setupForStatus() {
        switch schedulingStatus {
        case .pickingTypical:
            titleLabel.text = "Where do you prefer?"
        case .confirming:
            titleLabel.text = "Confirm preferred places"
            preselectSavedLocations()
        case .choosing:
            titleLabel.text = "Pick a place to meet"
        }
    }

    private func preselectSavedLocations() {
        selectedCampusLocations = campusLocations.filter { savedLocations.contains($0) }
        selectedCtownLocations = ctownLocations.filter { savedLocations.contains($0) }

        for campusLocation in selectedCampusLocations {
            guard let index = campusLocations.firstIndex(of: campusLocation) else { continue }
            locationsCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .top)
        }
        for ctownLocation in selectedCtownLocations {
            guard let index = ctownLocations.firstIndex(of: ctownLocation) else { continue }
            locationsCollectionView.selectItem(at: IndexPath(item: index, section: 1), animated: false, scrollPosition: .top)
        }

        updateNext()
    }

    private func setupViews() {
        titleLabel.font = ._24CircularStdMedium
        titleLabel.textColor = .black
        view.addSubview(titleLabel)

        let amPm = Time.isAm(time: pickedTime.time) ? "AM" : "PM"
        infoLabel.font = ._16CircularStdMedium
        infoLabel.text = isChoosing
            ? "Meeting at \(pickedTime.time) \(amPm) on \(pickedTime.day)"
            : "Pick three"
        infoLabel.textColor = .greenGray
        view.addSubview(infoLabel)

        let locationsCollectionViewLayout = UICollectionViewFlowLayout()
        locationsCollectionViewLayout.minimumLineSpacing = lineSpacing
        locationsCollectionViewLayout.minimumInteritemSpacing = interitemSpacing

        locationsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: locationsCollectionViewLayout)
        locationsCollectionView.allowsMultipleSelection = schedulingStatus != .choosing
        locationsCollectionView.showsVerticalScrollIndicator = false
        locationsCollectionView.showsHorizontalScrollIndicator = false
        locationsCollectionView.delegate = self
        locationsCollectionView.dataSource = self
        locationsCollectionView.backgroundColor = .clear
        locationsCollectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingPlaceCollectionViewCell.campusReuseId)
        locationsCollectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingPlaceCollectionViewCell.ctownReuseId)
        locationsCollectionView.register(
            LocationHeaderLabelView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: campusHeaderIdentifier
        )
        locationsCollectionView.register(
            LocationHeaderLabelView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ctownHeaderIdentifier
        )
        view.addSubview(locationsCollectionView)

        nextButton.setTitle("Finish", for: .normal)
        nextButton.layer.cornerRadius = 25
        nextButton.isEnabled = false
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

    }

    private func setupConstraints() {
        let backButtonPadding = LayoutHelper.shared.getCustomHorizontalPadding(size: 30)
        let bottomPadding = LayoutHelper.shared.getCustomVerticalPadding(size: isChoosing ? 60 : 30)
        let collectionViewPadding = 30
        let collectionViewSidePadding = isChoosing ? 80 : 32
        let infoPadding = 3
        let nextButtonSize = CGSize(width: 175, height: 50)
        let topPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 50)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(topPadding)
        }

        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(infoPadding)
        }

        locationsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(collectionViewSidePadding)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-collectionViewPadding)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(nextButtonSize)
        }

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().inset(backButtonPadding)
            make.width.equalTo(14)
            make.height.equalTo(24)
        }
    }

    // MARK: Button Action
    private func updateNext() {
        let enable = isChoosing ? pickedLocation != nil : totalSelectedLocations > 2

        nextButton.isEnabled = enable
        if enable {
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
        print("Updating match availabilities with...")
        print(match)

        NetworkManager.shared.updateMatchAvailabilities(match: match).observe { response in
            switch response {
            case .value(let value):
                if value.success {
                    UserDefaults.standard.insert(value: match.matchID, key: Constants.UserDefaults.matchIDLastReachedOut)
                    print("Successfully updated match availabilities")
                } else {
                    print("Failed to update match availabilities")
                }
            case .error(let error):
                print("Error when updating match availabilities: \(error)")
            }


        }
        navigationController?.pushViewController(HomeViewController(), animated: true)
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - UICollectionViewDelegate
extension SchedulingPlacesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        totalSelectedLocations < 3
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLocation: String

        switch locationSections[indexPath.section] {
        case .campus(let locations):
            selectedLocation = locations[indexPath.row]
            if isChoosing {
                pickedLocation = selectedLocation
            } else {
                selectedCampusLocations.append(selectedLocation)
            }
        case .ctown(let locations):
            selectedLocation = locations[indexPath.row]
            if isChoosing {
                pickedLocation = selectedLocation
            } else {
                selectedCtownLocations.append(selectedLocation)
            }
        }

        updateNext()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch locationSections[indexPath.section] {
        case .campus(let locations):
            selectedCampusLocations.removeAll { $0 == locations[indexPath.row] }
        case .ctown(let locations):
            selectedCtownLocations.removeAll { $0 == locations[indexPath.row] }
        }

        updateNext()
    }

}

// MARK: - UICollectionViewDataSource
extension SchedulingPlacesViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch locationSections[section] {
        case .campus(let locations): return locations.count
        case .ctown(let locations): return locations.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let location: String

        switch locationSections[indexPath.section] {
        case .campus(let locations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchedulingPlaceCollectionViewCell.campusReuseId, for: indexPath) as?
            SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }

            location = locations[indexPath.row]
            cell.configure(with: location, isPicking: isChoosing)
            return cell
        case .ctown(let locations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchedulingPlaceCollectionViewCell.ctownReuseId, for: indexPath) as?
            SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }

            location = locations[indexPath.row]
            cell.configure(with: location, isPicking: isChoosing)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let isCampus = indexPath.section == 0
        let header = isCampus
            ? collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                              withReuseIdentifier: campusHeaderIdentifier,
                                                              for: indexPath)
            : collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                              withReuseIdentifier: ctownHeaderIdentifier,
                                                              for: indexPath)
        guard let headerView = header as? LocationHeaderLabelView else { return header }
        headerView.configure(with: isCampus ? "Campus" : "Collegetown")
        return headerView
    }

}

extension SchedulingPlacesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let headersSize = 2 * headerHeight
        let numberColumns: CGFloat = isChoosing ? 1 : 2
        let numberRows = isChoosing
            ? CGFloat(totalSelectedLocations)
            : CGFloat(campusLocations.count/2).rounded() + CGFloat(ctownLocations.count/2).rounded()
        let itemWidth = (locationsCollectionView.bounds.size.width - lineSpacing) / CGFloat(numberColumns)
        let itemHeight = (locationsCollectionView.bounds.size.height - headersSize) / numberRows - lineSpacing

        return CGSize(width: itemWidth, height: min(isChoosing ? 50 : 43, itemHeight))
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: locationsCollectionView.bounds.size.width, height: headerHeight)
    }

}
