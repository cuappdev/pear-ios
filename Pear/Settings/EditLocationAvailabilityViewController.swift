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
    private var locationCollectionView: SchedulingLocationCollectionViewController!
    private let saveBarButtonItem = UIBarButtonItem()
    private let scheduleLocationLabel = UILabel()
    private let scheduleLocationSubLabel = UILabel()

    private let interitemSpacing: CGFloat = 12
    private let lineSpacing: CGFloat = 12

    private var selectedCampusLocations: [String] = []
    private var selectedCtownLocations: [String] = []
    private var selectedOnlineLocations: [String] = []
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
        locationsCollectionViewLayout.minimumLineSpacing = lineSpacing
        locationsCollectionViewLayout.minimumInteritemSpacing = interitemSpacing

        locationCollectionView = SchedulingLocationCollectionViewController(updateSelections: { selectedCampus, selectedCtown, selectedOnline  in
            self.selectedCampusLocations = selectedCampus
            self.selectedCtownLocations = selectedCtown
            self.selectedOnlineLocations = selectedOnline
        }, updateNext: nil, updatePickedLocation: nil, schedulingStatus: nil, isChoosing: nil, collectionViewLayout: locationsCollectionViewLayout, interitemSpacing: interitemSpacing, lineSpacing: lineSpacing)
        addChild(locationCollectionView)
        view.addSubview(locationCollectionView.view)
        locationCollectionView.didMove(toParent: self)

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
        let ctownLocations = selectedCtownLocations.map { Location(area: "Collegetown", name: $0) }
        let campusLocations = selectedCampusLocations.map { Location(area: "Campus", name: $0) }
        let onlineLocations = selectedOnlineLocations.map { Location(area: "Online", name: $0) }
        let locations = ctownLocations + campusLocations + onlineLocations
        // TODO: Fill in network call to save availability
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

        locationCollectionView.view.snp.makeConstraints { make in
            make.top.equalTo(scheduleLocationSubLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).inset(30)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserPreferredLocations()
    }
    
    private func getUserPreferredLocations() {
        // TODO: Fill in this network call
    }

}

