//
//  SchedulingPlacesViewController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - UICollectionView Header
private class HeaderLabel: UICollectionReusableView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = ._16CircularStdBook
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with text: String) { label.text = text }

}

class SchedulingPlacesViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let infoLabel = UILabel()
    private var locationsCollectionView: UICollectionView!
    private let nextButton = UIButton()
    private let titleLabel = UILabel()

    // Reuse Identifiers
    private let campusReuseIdentifier = "campusReuseIdentifier"
    private let campusHeaderIdentifier = "campusHeaderIdentifier"
    private let ctownReuseIdentiifier = "ctownReuseIdentiifier"
    private let ctownHeaderIdentifier = "ctownHeaderIdentifier"

    // MARK: - Collection View Sections
    private enum Section {
        case campus([String])
        case ctown([String])
    }

    // MARK: - Data Vars
    private var locationSections: [Section] = []
    private var selectedCampusLocations = [String]()
    private var selectedCtownLocations = [String]()

    // Whether user is picking a location from match's locations
    private var isPicking: Bool
    // Location user picked from match's locations
    private var pickedLocation: String!

    // Data received from `SchedulingTimeViewController`
    private var availabilities: [String: [String]] = [:]
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
    private let matchLocations = [
        "Goldie's Cafe",
        "Green Dragon",
        "Kung Fu Tea"
    ]

    init(isPicking: Bool, availabilities: [String: [String]], pickedTime: (day: String, time: String)) {
        self.isPicking = isPicking
        if isPicking {
            self.pickedTime = pickedTime
        } else {
            self.availabilities = availabilities
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true // TODO Remove this

        titleLabel.font = ._24CircularStdMedium
        titleLabel.text = "Where do you prefer?"
        titleLabel.textColor = .textBlack
        view.addSubview(titleLabel)

        var scheduledTime = ""
        var amPm = ""
        if Time.isAm(time: pickedTime.time) {
            amPm = "AM"
        } else if Time.isPm(time: pickedTime.time) {
            amPm = "PM"
        }
        scheduledTime = "Meeting at \(pickedTime.time) \(amPm) on \(pickedTime.day)"
        infoLabel.font = ._16CircularStdMedium
        infoLabel.text = isPicking ? scheduledTime :  "Pick three"
        infoLabel.textColor = .greenGray
        view.addSubview(infoLabel)

        let locationsCollectionViewLayout = UICollectionViewFlowLayout()
        locationsCollectionViewLayout.minimumLineSpacing = lineSpacing
        locationsCollectionViewLayout.minimumInteritemSpacing = interitemSpacing

        locationsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: locationsCollectionViewLayout)
        locationsCollectionView.allowsMultipleSelection = !isPicking
        locationsCollectionView.showsVerticalScrollIndicator = false
        locationsCollectionView.showsHorizontalScrollIndicator = false
        locationsCollectionView.delegate = self
        locationsCollectionView.dataSource = self
        locationsCollectionView.backgroundColor = .clear
        locationsCollectionView.layer.masksToBounds = false
        locationsCollectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: campusReuseIdentifier)
        locationsCollectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: ctownReuseIdentiifier)
        locationsCollectionView.register(HeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: campusHeaderIdentifier)
        locationsCollectionView.register(HeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ctownHeaderIdentifier)
        view.addSubview(locationsCollectionView)

        nextButton.setTitle("Finish", for: .normal)
        nextButton.layer.cornerRadius = 25
        nextButton.isEnabled = false
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        if isPicking {
            campusLocations = campusLocations.filter { matchLocations.contains($0) }
            ctownLocations = ctownLocations.filter { matchLocations.contains($0) }
        }

        // Create Datasource for CollectionView
        locationSections = [
            .campus(campusLocations),
            .ctown(ctownLocations)
        ]

        setupConstraints()
    }

    private func setupConstraints() {
        let backButtonPadding = LayoutHelper.shared.getCustomHorizontalPadding(size: 30)
        let bottomPadding = LayoutHelper.shared.getCustomVerticalPadding(size: isPicking ? 60 : 30)
        let collectionViewPadding = 30
        let collectionViewSidePadding = isPicking ? 80 : 32
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
        let enable = selectedCtownLocations.count + selectedCampusLocations.count > 2 || pickedLocation != nil
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
        // TODO implement
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: false)
    }

}

// MARK: - UICollectionViewDelegate
extension SchedulingPlacesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Only three locations can be selected
        if selectedCampusLocations.count + selectedCtownLocations.count < 3 {
            let section = locationSections[indexPath.section]
            switch section {
            case .campus(let locations):
                let location = locations[indexPath.row]
                if isPicking {
                    pickedLocation = location
                } else {
                    selectedCampusLocations.append(location)
                }
            case .ctown(let locations):
                let location = locations[indexPath.row]
                if isPicking {
                    pickedLocation = location
                } else {
                    selectedCtownLocations.append(location)
                }
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? SchedulingPlaceCollectionViewCell {
                cell.changeSelection(selected: true)
            }
            updateNext()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let section = locationSections[indexPath.section]
        switch section {
        case .campus(let locations):
            selectedCampusLocations.removeAll { $0 == locations[indexPath.row] }
        case .ctown(let locations):
            selectedCtownLocations.removeAll { $0 == locations[indexPath.row] }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? SchedulingPlaceCollectionViewCell {
            cell.changeSelection(selected: false)
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
        switch locationSections[indexPath.section] {
        case .campus(let locations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: campusReuseIdentifier, for: indexPath) as?
            SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: locations[indexPath.row], isPicking: isPicking)
            return cell
        case .ctown(let locations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ctownReuseIdentiifier, for: indexPath) as?
            SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: locations[indexPath.row], isPicking: isPicking)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let isCampus = indexPath.section == 0
        let header = isCampus
            ? collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: campusHeaderIdentifier, for: indexPath)
            : collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ctownHeaderIdentifier, for: indexPath)
        guard let headerView = header as? HeaderLabel else { return header }
        headerView.configure(with: isCampus ? "Campus" : "Collegetown")
        return headerView
    }

}

extension SchedulingPlacesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let headersSize = 2 * headerHeight
        let numberColumns: CGFloat = isPicking ? 1 : 2
        let numberRows = isPicking
            ? CGFloat(campusLocations.count + ctownLocations.count)
            : CGFloat(campusLocations.count/2).rounded() + CGFloat(ctownLocations.count/2).rounded()
        let itemWidth = (locationsCollectionView.bounds.size.width - lineSpacing) / CGFloat(numberColumns)
        let itemHeight = (locationsCollectionView.bounds.size.height - headersSize) / numberRows - lineSpacing
        return CGSize(width: itemWidth, height: min(isPicking ? 50 : 43, itemHeight))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: locationsCollectionView.bounds.size.width, height: headerHeight)
    }

}
