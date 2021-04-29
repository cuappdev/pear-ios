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
    private let nextButton = UIButton()
    private let titleLabel = UILabel()
    private var locationCollectionView: SchedulingLocationCollectionViewController!

    private let schedulingStatus: SchedulingStatus
    private var isChoosing: Bool { .choosing ~= schedulingStatus }
    // Location user picked from match's locations
    private var pickedLocation: String?

    private var selectedCampusLocations: [String] = []
    private var selectedCtownLocations: [String] = []
    private let interitemSpacing: CGFloat = 12
    private let lineSpacing: CGFloat = 12

    // Data received from `SchedulingTimeViewController`
    private var match: Match

    init(status: SchedulingStatus, match: Match) {
        self.schedulingStatus = status
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
        setupForStatus()
        setupConstraints()
        updateNext(totalSelectedLocations: 0)
    }

    private func setupForStatus() {
        switch schedulingStatus {
        case .pickingTypical:
            titleLabel.text = "Where do you prefer?"
        case .confirming:
            titleLabel.text = "Confirm preferred places"
        case .choosing:
            titleLabel.text = "Pick a place to meet"
        }
    }

    private func setupViews() {
        titleLabel.font = ._24CircularStdMedium
        titleLabel.textColor = .black
        view.addSubview(titleLabel)

        infoLabel.font = ._16CircularStdMedium
        infoLabel.textColor = .greenGray
        if let firstSelectedTime = match.availabilities.first {
            let day = firstSelectedTime.day
            let time = Time.floatToStringTime(time: firstSelectedTime.times.first ?? 0)
            let amPm = Time.isAm(time: time) ? "AM" : "PM"

            infoLabel.text = isChoosing
              ? "Meeting at \(time) \(amPm) on \(day)"
              : "Pick three"
        } else {
            infoLabel.text = "Pick three"
        }
        view.addSubview(infoLabel)

        let locationsCollectionViewLayout = UICollectionViewFlowLayout()
        locationsCollectionViewLayout.minimumLineSpacing = lineSpacing
        locationsCollectionViewLayout.minimumInteritemSpacing = interitemSpacing


        locationCollectionView = SchedulingLocationCollectionViewController(updateSelections: { selectedCampus, selectedCtown in
            self.selectedCampusLocations = selectedCampus
            self.selectedCtownLocations = selectedCtown
        }, updateNext: { totalSelected in
            self.updateNext(totalSelectedLocations: totalSelected)
        }, updatePickedLocation: { location in
            self.pickedLocation = location
        }, schedulingStatus: schedulingStatus, isChoosing: isChoosing, collectionViewLayout: locationsCollectionViewLayout, interitemSpacing: interitemSpacing, lineSpacing: lineSpacing)
        addChild(locationCollectionView)
        view.addSubview(locationCollectionView.view)
        locationCollectionView.didMove(toParent: self)

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

        locationCollectionView.view.snp.makeConstraints { make in
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
            make.size.equalTo(Constants.Onboarding.backButtonSize)
        }
    }

    // MARK: Button Action
    private func updateNext(totalSelectedLocations: Int) {
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
        NetworkManager.shared.updateMatchAvailabilities(match: match).observe { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case .value(let value):
                    if value.success {
                        UserDefaults.standard.set(self.match.matchID, forKey: Constants.UserDefaults.matchIDLastReachedOut)
                            self.navigationController?.pushViewController(HomeViewController(), animated: true)
                    } else {
                        self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                    }
                case .error:
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

}
