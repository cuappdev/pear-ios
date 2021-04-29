//
//  SchedulingLocationCollectionViewController.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 4/28/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class SchedulingLocationCollectionViewController: UICollectionViewController {

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

    private let schedulingStatus: SchedulingStatus?
    private var isChoosing: Bool?

    private let headerHeight: CGFloat = 50
    private let interitemSpacing: CGFloat
    private let lineSpacing: CGFloat

    // TODO: Replace with networking when available
    private var campusLocations = [
        "Atrium Café",
        "Café Jennie",
        "Gimme Coffee",
        "Goldie's Café",
        "Green Dragon",
        "Libe Café",
        "Mac's Café",
        "Martha's Café",
        "Mattin's Café",
        "Temple of Zeus"
    ]
    private var ctownLocations = [
        "Kung Fu Tea",
        "Starbucks",
        "CTB",
        "U Tea"
    ]
    // TODO replace once the match includes location information
    private let matchLocations: [String] = [
        "Atrium Café",
        "Café Jennie",
        "Gimme Coffee",
        "Goldie's Café",
        "Green Dragon",
        "Libe Café",
        "Mac's Café",
        "Martha's Café",
        "Mattin's Café",
        "Temple of Zeus",
        "Kung Fu Tea",
        "Starbucks",
        "CTB",
        "U Tea"
    ]

    private let savedLocations: [String] = []
    private var updateNext: ((Int) -> ())?
    private var updatePickedLocation: ((String) -> ())?
    private var updateSelections: ([String], [String]) -> ()


    init(updateSelections: @escaping ([String], [String]) -> (), updateNext: ((Int) -> ())?, updatePickedLocation: ((String) -> ())?, schedulingStatus: SchedulingStatus?, isChoosing: Bool?, collectionViewLayout: UICollectionViewLayout, interitemSpacing: CGFloat, lineSpacing: CGFloat) {
        self.updateSelections = updateSelections
        self.updateNext = updateNext
        self.updatePickedLocation = updatePickedLocation
        self.isChoosing = isChoosing
        self.schedulingStatus = schedulingStatus
        self.interitemSpacing = interitemSpacing
        self.lineSpacing = lineSpacing
        super.init(collectionViewLayout: collectionViewLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .clear

        collectionView.allowsMultipleSelection = schedulingStatus != .choosing
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingPlaceCollectionViewCell.campusReuseId)
        collectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingPlaceCollectionViewCell.ctownReuseId)
        collectionView.register(
            LocationHeaderLabelView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: campusHeaderIdentifier
        )
        collectionView.register(
            LocationHeaderLabelView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ctownHeaderIdentifier
        )
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }

        setupLocationSections()
    }

    // MARK: - Setup Functions
    private func setupLocationSections() {
        if let isChoosing = isChoosing, isChoosing {
            campusLocations = campusLocations.filter(matchLocations.contains)
            ctownLocations = ctownLocations.filter(matchLocations.contains)
        }
        locationSections = [
            .campus(campusLocations),
            .ctown(ctownLocations)
        ]
        if schedulingStatus == .confirming {
            preselectSavedLocations()
        }
    }

    private func preselectSavedLocations() {
        selectedCampusLocations = campusLocations.filter { savedLocations.contains($0) }
        selectedCtownLocations = ctownLocations.filter { savedLocations.contains($0) }

        for campusLocation in selectedCampusLocations {
            guard let index = campusLocations.firstIndex(of: campusLocation) else { continue }
            collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .top)
        }
        for ctownLocation in selectedCtownLocations {
            guard let index = ctownLocations.firstIndex(of: ctownLocation) else { continue }
            collectionView.selectItem(at: IndexPath(item: index, section: 1), animated: false, scrollPosition: .top)
        }

        if let updateNext = updateNext {
            updateNext(selectedCampusLocations.count + selectedCtownLocations.count)
        }
    }


    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedCampusLocations.count + selectedCtownLocations.count < 3
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLocation: String

        switch locationSections[indexPath.section] {
        case .campus(let locations):
            selectedLocation = locations[indexPath.row]
            if let isChoosing = isChoosing, let updatePickedLocation = updatePickedLocation, isChoosing {
                updatePickedLocation(selectedLocation)
            } else {
                selectedCampusLocations.append(selectedLocation)
            }
        case .ctown(let locations):
            selectedLocation = locations[indexPath.row]
            if let isChoosing = isChoosing, let updatePickedLocation = updatePickedLocation, isChoosing {
                updatePickedLocation(selectedLocation)
            } else {
                selectedCtownLocations.append(selectedLocation)
            }
        }

        updateSelections(selectedCampusLocations, selectedCtownLocations)
        if let updateNext = updateNext {
            updateNext(selectedCampusLocations.count + selectedCtownLocations.count)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch locationSections[indexPath.section] {
        case .campus(let locations):
            selectedCampusLocations.removeAll { $0 == locations[indexPath.row] }
        case .ctown(let locations):
            selectedCtownLocations.removeAll { $0 == locations[indexPath.row] }
        }

        updateSelections(selectedCampusLocations, selectedCtownLocations)
        if let updateNext = updateNext {
            updateNext(selectedCampusLocations.count + selectedCtownLocations.count)
        }
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch locationSections[section] {
        case .campus(let locations): return locations.count
        case .ctown(let locations): return locations.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let location: String

        switch locationSections[indexPath.section] {
        case .campus(let locations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchedulingPlaceCollectionViewCell.campusReuseId, for: indexPath) as?
            SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }
            location = locations[indexPath.row]
            cell.configure(with: location, isPicking: isChoosing ?? false)

            return cell
        case .ctown(let locations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchedulingPlaceCollectionViewCell.ctownReuseId, for: indexPath) as?
            SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }
            location = locations[indexPath.row]
            cell.configure(with: location, isPicking: isChoosing ?? false)
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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

extension SchedulingLocationCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let headersSize = 2 * headerHeight
        let numberColumns: CGFloat = (isChoosing ?? false) ? 1 : 2
        let numberRows = (isChoosing ?? false)
            ? CGFloat(totalSelectedLocations)
            : CGFloat(campusLocations.count/2).rounded() + CGFloat(ctownLocations.count/2).rounded()
        let itemWidth = (collectionView.bounds.size.width - lineSpacing) / CGFloat(numberColumns)
        let itemHeight = (collectionView.bounds.size.height - headersSize) / numberRows - lineSpacing

        return CGSize(width: itemWidth, height: min((isChoosing ?? false) ? 50 : 43, itemHeight))
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.size.width, height: headerHeight)
    }
}
