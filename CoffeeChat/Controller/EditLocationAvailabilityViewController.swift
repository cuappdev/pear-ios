//
//  EditLocationAvailabilityViewController.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 11/19/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class EditLocationAvailabilityViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private var locationsCollectionView: UICollectionView!
    private let saveBarButtonItem = UIBarButtonItem()
    private let scheduleLocationLabel = UILabel()
    private let scheduleLocationSubLabel = UILabel()

    // MARK: - Location CollectionView Sections
    private enum LocationSection {
        case campus([String])
        case ctown([String])
    }

    // MARK: - Location Data Vars
    private let campusHeaderId = "campusHeaderIdentifier"
    private let ctownHeaderId = "ctownHeaderIdentifier"

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

    private var savedLocations: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        title = "Edit Availabilities"
        setupNavigationBar()

        scheduleLocationLabel.text = "Where do you prefer?"
        scheduleLocationLabel.font = ._20CircularStdBook
        scheduleLocationLabel.textColor = .black
        view.addSubview(scheduleLocationLabel)

        scheduleLocationSubLabel.text = "pick three"
        scheduleLocationSubLabel.font = ._16CircularStdBook
        scheduleLocationSubLabel.textColor = .greenGray
        view.addSubview(scheduleLocationSubLabel)

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
        locationsCollectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingPlaceCollectionViewCell.campusReuseId)
        locationsCollectionView.register(SchedulingPlaceCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingPlaceCollectionViewCell.ctownReuseId)
        locationsCollectionView.register(LocationHeaderLabelView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: campusHeaderId)
        locationsCollectionView.register(LocationHeaderLabelView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ctownHeaderId)
        locationsCollectionView.isScrollEnabled = false
        view.addSubview(locationsCollectionView)

        selectedCampusLocations = campusLocations.filter { savedLocations.contains($0) }
        selectedCtownLocations = ctownLocations.filter { savedLocations.contains($0) }

        locationSections = [
            .campus(campusLocations),
            .ctown(ctownLocations)
        ]

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
        let ctownLocations: [Location] = selectedCampusLocations.map { Location(area: "Collegetown", name: $0) }
        let campusLocations: [Location] = selectedCampusLocations.map { Location(area: "Campus", name: $0) }
        let locations = ctownLocations + campusLocations
        NetworkManager.shared.updatePreferredLocations(locations: locations).observe { response in
            switch response {
            case .value(let value):
                guard value.success else { return }
                DispatchQueue.main.async {
                    print("Update time availabilities success")
                    self.navigationController?.popViewController(animated: true)
                }
            case .error(let error):
                print(error)
            }
        }
    }

    private func setupConstraints() {
        scheduleLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }

        scheduleLocationSubLabel.snp.makeConstraints { make in
            make.top.equalTo(scheduleLocationLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        locationsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleLocationSubLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).inset(30)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserAvailabilities()
    }
    
    private func getUserAvailabilities() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getUser(netId: netId).observe { response in
            switch response {
            case .value(let value):
                guard value.success else { return }
                DispatchQueue.main.async {
                    self.savedLocations = value.data.preferredLocations.map { return $0.name }
                    self.locationsCollectionView.reloadData()
                }
            case .error(let error):
                print(error)
            }
        }
    }

}

extension EditLocationAvailabilityViewController: UICollectionViewDataSource {

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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchedulingPlaceCollectionViewCell.campusReuseId, for: indexPath) as? SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }
                let location = locations[indexPath.item]
                cell.configure(with: location, isPicking: false)
                if savedLocations.contains(location) {
                    cell.isSelected = true
                    locationsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                }
                return cell
        case .ctown(let locations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchedulingPlaceCollectionViewCell.ctownReuseId, for: indexPath) as? SchedulingPlaceCollectionViewCell else { return UICollectionViewCell() }
                let location = locations[indexPath.item]
                cell.configure(with: location, isPicking: false)
                if savedLocations.contains(location) {
                    cell.isSelected = true
                    locationsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                }
                return cell
            }
        }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: campusHeaderId, for: indexPath)
            guard let headerView = header as? LocationHeaderLabelView else { return header }
            headerView.configure(with: "Campus")
            return headerView
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ctownHeaderId, for: indexPath)
        guard let headerView = header as? LocationHeaderLabelView else { return header }
        headerView.configure(with: "Collegetown")
        return headerView
    }

}

extension EditLocationAvailabilityViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedCampusLocations.count + selectedCtownLocations.count < 3
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
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

extension EditLocationAvailabilityViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberColumns: CGFloat = 2
            let itemWidth = (locationsCollectionView.bounds.size.width - locationLineSpacing) / CGFloat(numberColumns)
            return CGSize(width: itemWidth, height: 42)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == locationsCollectionView {
            return CGSize(width: locationsCollectionView.bounds.size.width, height: headerHeight)
        }
        return CGSize(width: 0, height: 0)
    }
}
