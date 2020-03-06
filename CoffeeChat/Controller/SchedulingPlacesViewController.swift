//
//  SchedulingPlacesViewController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

private class ScheduleFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        itemSize = CGSize(width: 150, height: 43)
        minimumLineSpacing = 12
        let width = collectionView?.superview?.bounds.width ?? 0
        print(width)
        headerReferenceSize = .init(width: width, height: 56)
    }

}

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

private struct Section {
    let type: SectionType
    var items: [ItemType]
}

private enum SectionType {
    case campus
    case ctown
}

private enum ItemType {
    case campus(String)
    case ctown(String)
}

class SchedulingPlacesViewController: UIViewController {

    // MARK: - Private View Vars
    private let locationsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ScheduleFlowLayout())
    private let infoLabel = UILabel()
    private let nextButton = UIButton()
    private let titleLabel = UILabel()

    private let campusReuseIdentifier = "campus"
    private let campusHeaderIdentifier = "campusHead"
    private let ctownReuseIdentiifier = "ctown"
    private let ctownHeaderIdentifier = "campusHead"

    // MARK: - Data
    private let campusLocations = [
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
    private let ctownLocations = [
      "Kung Fu Tea",
      "Starbucks",
      "Mango Mango",
      "U Tea"
    ]
    private var selectedCampusLocations = [String]()
    private var selectedCtownLocations = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true // TODO Remove this

        titleLabel.font = UIFont._24CircularStdMedium
        titleLabel.text = "Where do you prefer?"
        titleLabel.textColor = .textBlack
        view.addSubview(titleLabel)

        infoLabel.font = UIFont._16CircularStdBook
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
        nextButton.layer.cornerRadius = 27
        nextButton.isEnabled = false
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        setupConstraints()
    }

    private func setupConstraints() {
        let topPadding = 92
        let infoPadding = 3
        let titlePadding = 20
        let collectionViewSize = CGSize(width: 312, height: 453)
        let nextButtonSize = CGSize(width: 175, height: 53)
        let nextPadding = 38

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(topPadding)
        }

        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(infoPadding)
        }

//        campusLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(infoLabel.snp.bottom).offset(campusPadding)
//        }

        locationsCollectionView.snp.makeConstraints { make in
            make.size.equalTo(collectionViewSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(titlePadding)
        }

//        ctownLabel.snp.makeConstraints { make in
//          make.centerX.equalToSuperview()
//          make.top.equalTo(campusCollectionView.snp.bottom).offset(campusPadding)
//        }

//        ctownCollectionView.snp.makeConstraints { make in
//            make.size.equalTo(ctownCollectionViewSize)
//            make.centerX.equalToSuperview()
//            make.top.equalTo(ctownLabel.snp.bottom).offset(collectionViewPadding)
//        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(locationsCollectionView.snp.bottom).offset(nextPadding)
        }
    }

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
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            nextButton.layer.shadowOpacity = 0
            nextButton.layer.shadowRadius = 0
        }
    }

    @objc private func nextButtonPressed() {
        print("campus: \(selectedCampusLocations)")
        print("ctown: \(selectedCtownLocations)")
    }

}

extension SchedulingPlacesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedCampusLocations.append(campusLocations[indexPath.row])
        case 1:
            selectedCtownLocations.append(ctownLocations[indexPath.row])
        default:
            print("read the bible")
        }
        (collectionView.cellForItem(at: indexPath) as? SchedulingCollectionViewCell)?.changeSelection(selected: true)
        updateNext()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedCampusLocations.append(campusLocations[indexPath.row])
        case 1:
            selectedCtownLocations.append(ctownLocations[indexPath.row])
        default:
            print("read the bible")
        }
        (collectionView.cellForItem(at: indexPath) as? SchedulingCollectionViewCell)?.changeSelection(selected: false)
        updateNext()
    }

}

extension SchedulingPlacesViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? campusLocations.count : ctownLocations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isCampus = indexPath.section == 0
        let reuseID = isCampus ? campusReuseIdentifier : ctownReuseIdentiifier
        let location = (isCampus ? campusLocations : ctownLocations)[indexPath.row]
        guard let cell = locationsCollectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as?
            SchedulingCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: location)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print(indexPath)
        let header = indexPath.row == 0
        ? collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: campusHeaderIdentifier, for: indexPath)
        : collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ctownHeaderIdentifier, for: indexPath)

        guard let headerView = header as? HeaderLabel else { return header }
        headerView.configure(with: indexPath.row == 0 ? "Campus" : "Collegetown")
        return headerView
    }

}

