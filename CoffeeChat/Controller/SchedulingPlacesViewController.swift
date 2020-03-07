//
//  SchedulingPlacesViewController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - UICollectionViewFlowLayout
private class ScheduleFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        // Columns and Rows of entire screen
        let numberColumns: CGFloat = 2
        let numberRows: CGFloat = 7
        // itemSize = CGSize(width: 150, height: 43)

        // minimumLineSpacing = LayoutHelper.shared.getCustomHoriztonalPadding(size: 12)
        guard let collectionView = collectionView else {  return }
        minimumLineSpacing = 12
        minimumInteritemSpacing = 12
        let headerWidth = collectionView.superview?.bounds.width ?? 0
        let headerHeight: CGFloat = 56
        headerReferenceSize = CGSize(width: headerWidth, height: headerHeight)
        let itemWidth = (collectionView.bounds.size.width - minimumLineSpacing) / CGFloat(numberColumns)

        let headersSize = 2 * headerHeight
        let lineSpacings = minimumLineSpacing * CGFloat(numberRows - 2)
        let itemHeight = (collectionView.bounds.size.height - headersSize - lineSpacings) / numberRows
        itemSize = CGSize(width: itemWidth, height: itemHeight)

//        itemSize = CGSize(
//            width: LayoutHelper.shared.getCustomHorizontalPadding(size: 150),
//            height: LayoutHelper.shared.getCustomVerticalPadding(size: 43)
//        )

    }

}

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) { label.text = text }

}

class SchedulingPlacesViewController: UIViewController {

    // MARK: - Private View Vars
    private let locationsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ScheduleFlowLayout())
    private let infoLabel = UILabel()
    private let nextButton = UIButton()
    private let backButton = UIButton()
    private let titleLabel = UILabel()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true // TODO Remove this

        titleLabel.font = ._24CircularStdMedium
        titleLabel.text = "Where do you prefer?"
        titleLabel.textColor = .textBlack
        view.addSubview(titleLabel)

        infoLabel.font = ._16CircularStdBook
        infoLabel.text = "Pick three"
        infoLabel.textColor = .textLightGray
        view.addSubview(infoLabel)

        locationsCollectionView.allowsMultipleSelection = true
        locationsCollectionView.showsVerticalScrollIndicator = false
        locationsCollectionView.showsHorizontalScrollIndicator = false
        locationsCollectionView.delegate = self
        locationsCollectionView.dataSource = self
        locationsCollectionView.backgroundColor = .clear
        locationsCollectionView.layer.masksToBounds = false
        locationsCollectionView.register(SchedulingCollectionViewCell.self, forCellWithReuseIdentifier: campusReuseIdentifier)
        locationsCollectionView.register(SchedulingCollectionViewCell.self, forCellWithReuseIdentifier: ctownReuseIdentiifier)
        locationsCollectionView.register(HeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: campusHeaderIdentifier)
        locationsCollectionView.register(HeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ctownHeaderIdentifier)
        view.addSubview(locationsCollectionView)

        nextButton.setTitle("Finish", for: .normal)
        nextButton.layer.cornerRadius = LayoutHelper.shared.getCustomVerticalPadding(size: 27)
        nextButton.isEnabled = false
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        backButton.setTitle("Go back", for: .normal)
        backButton.backgroundColor = .clear
        backButton.setTitleColor(.greenGray, for: .normal)
        backButton.titleLabel?.font = ._16CircularStdBook
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        // TODO: Replace with networking when available
        let campusLocations = [
          "Atrium Cafe",
          "Cafe Jennie",
          "Gimme Coffee",
          "Goldie's Cafe",
          "Green Dragon",
          "Libe Cafe",
          "Mac's Cafe",
          "Martha's Cafe",
          "Mattin's Cafe",
          "Temple of Zues"
        ]
        let ctownLocations = [
          "Kung Fu Tea",
          "Starbucks",
          "Mango Mango",
          "U Tea"
        ]

        // Create Datasource for CollectionView
        locationSections = [
            .campus(campusLocations),
            .ctown(ctownLocations)
        ]

        setupConstraints()
    }

    private func setupConstraints() {
        print("screen is \(UIScreen.main.bounds)")
        print("layout is \(CGSize(width: 375, height: 812))")
        let backPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 24)
        let infoPadding = 3
        // let nextPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 38)
        let nextPadding = 38
        // let titlePadding = LayoutHelper.shared.getShortenedCustomVertPadding(size: 20)
        // let titlePadding = LayoutHelper.shared.getCustomVerticalPadding(size: 20)
        let titlePadding = 20
        let topPadding = LayoutHelper.shared.getShortenedCustomVertPadding(size: 92)

        let collectionViewSize = CGSize(
            width: LayoutHelper.shared.getCustomHorizontalPadding(size: 312),
            height: LayoutHelper.shared.getCustomVerticalPadding(size: 469)
        )
        let nextButtonSize = CGSize(
            width: LayoutHelper.shared.getCustomVerticalPadding(size:175),
            height: LayoutHelper.shared.getCustomVerticalPadding(size: 53)
        )

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(topPadding)
        }

        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(infoPadding)
        }

        locationsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom)
            // make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(LayoutHelper.shared.getCustomHorizontalPadding(size: 32))
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            //make.width.equalTo(LayoutHelper.shared.getCustomHorizontalPadding(size: 311))
            //make.width.equalTo(311)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(194)
            // make.size.equalTo(collectionViewSize)
            // make.centerX.equalToSuperview()
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(locationsCollectionView.snp.bottom).offset(nextPadding)
        }

        backButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(59)
            // make.top.equalTo(nextButton.snp.bottom).offset(backPadding)
        }
    }

    // MARK: Button Action
    private func updateNext() {
        let enable = selectedCtownLocations.count + selectedCampusLocations.count > 2
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
        print("selectedCampusLocations: \(selectedCampusLocations)")
        print("selectedCtownLocations: \(selectedCtownLocations)")
    }

    @objc private func backButtonPressed() {
        // TODO implement
        print("selectedCampusLocations: \(selectedCampusLocations)")
        print("selectedCtownLocations: \(selectedCtownLocations)")

    }


}

// MARK: - UICollectionViewDelegate
extension SchedulingPlacesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = locationSections[indexPath.section]
        switch section {
        case .campus(let locations):
            selectedCampusLocations.append(locations[indexPath.row])
        case .ctown(let locations):
            selectedCtownLocations.append(locations[indexPath.row])
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? SchedulingCollectionViewCell {
            cell.changeSelection(selected: true)
        }
        updateNext()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let section = locationSections[indexPath.section]
        switch section {
        case .campus(let locations):
            selectedCampusLocations.removeAll { $0 == locations[indexPath.row] }
        case .ctown(let locations):
            selectedCtownLocations.removeAll { $0 == locations[indexPath.row] }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? SchedulingCollectionViewCell {
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
            SchedulingCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: locations[indexPath.row])
            return cell
        case .ctown(let locations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ctownReuseIdentiifier, for: indexPath) as?
            SchedulingCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: locations[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = indexPath.row == 0
        ? collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: campusHeaderIdentifier, for: indexPath)
        : collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ctownHeaderIdentifier, for: indexPath)

        guard let headerView = header as? HeaderLabel else { return header }
        headerView.configure(with: indexPath.row == 0 ? "Campus" : "Collegetown")
        return headerView
    }

}
