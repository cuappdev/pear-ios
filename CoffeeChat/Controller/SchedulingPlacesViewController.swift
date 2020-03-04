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
    }

}

class SchedulingPlacesViewController: UIViewController {

    // MARK: - Private View Vars
    private let campusCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ScheduleFlowLayout())
    private let campusLabel = UILabel()
    private let ctownCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ScheduleFlowLayout())
    private let ctownLabel = UILabel()
    private let infoLabel = UILabel()
    private let nextButton = UIButton()
    private let titleLabel = UILabel()

    private let campusReuseIdentifier = "campus"
    private let ctownReuseIdentiifier = "ctown"

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
        navigationController?.navigationBar.isHidden = true // TODO" Remove this


        titleLabel.font = UIFont._24CircularStdMedium
        titleLabel.text = "Where do you prefer?"
        titleLabel.textColor = .textBlack
        view.addSubview(titleLabel)

        infoLabel.font = UIFont._16CircularStdMedium
        infoLabel.text = "Pick three"
        infoLabel.textColor = .textLightGray
        view.addSubview(infoLabel)

        campusLabel.font = UIFont._16CircularStdMedium
        campusLabel.text = "Campus"
        campusLabel.textColor = .textBlack
        view.addSubview(campusLabel)

        campusCollectionView.allowsMultipleSelection = true
        campusCollectionView.showsVerticalScrollIndicator = false
        campusCollectionView.showsHorizontalScrollIndicator = false
        campusCollectionView.delegate = self
        campusCollectionView.dataSource = self
        campusCollectionView.backgroundColor = .clear
        campusCollectionView.register(SchedulingCollectionViewCell.self, forCellWithReuseIdentifier: campusReuseIdentifier)
        campusCollectionView.layer.masksToBounds = false
        view.addSubview(campusCollectionView)

        ctownLabel.font = UIFont._16CircularStdMedium
        ctownLabel.text = "Collegetown"
        ctownLabel.textColor = .textBlack
        view.addSubview(ctownLabel)

        ctownCollectionView.allowsMultipleSelection = true
        ctownCollectionView.showsVerticalScrollIndicator = false
        ctownCollectionView.showsHorizontalScrollIndicator = false
        ctownCollectionView.delegate = self
        ctownCollectionView.dataSource = self
        ctownCollectionView.backgroundColor = .clear
        ctownCollectionView.backgroundColor = .clear
        ctownCollectionView.register(SchedulingCollectionViewCell.self, forCellWithReuseIdentifier: ctownReuseIdentiifier)
        ctownCollectionView.layer.masksToBounds = false
        view.addSubview(ctownCollectionView)

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
        let campusPadding = 20
        let collectionViewPadding = 16
        let campusCollectionViewSize = CGSize(width: 312, height: 263) // do i need more spacing ?
        let ctownCollectionViewSize = CGSize(width: 312, height: 98) // do i need more spacing ?
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

        campusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(campusPadding)
        }

        campusCollectionView.snp.makeConstraints { make in
            make.size.equalTo(campusCollectionViewSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(campusLabel.snp.bottom).offset(collectionViewPadding)
        }

        ctownLabel.snp.makeConstraints { make in
          make.centerX.equalToSuperview()
          make.top.equalTo(campusCollectionView.snp.bottom).offset(campusPadding)
        }

        ctownCollectionView.snp.makeConstraints { make in
            make.size.equalTo(ctownCollectionViewSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(ctownLabel.snp.bottom).offset(collectionViewPadding)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(ctownCollectionView.snp.bottom).offset(nextPadding)
        }
    }

    @objc private func nextButtonPressed() {
        print("TODO: implement")
    }

}

extension SchedulingPlacesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelect")
        if collectionView == campusCollectionView {
            selectedCampusLocations.append(campusLocations[indexPath.row])
        } else {
            selectedCtownLocations.append(ctownLocations[indexPath.row])
        }
        print( (collectionView.cellForItem(at: indexPath) as? SchedulingCollectionViewCell))
        (collectionView.cellForItem(at: indexPath) as? SchedulingCollectionViewCell)?.changeSelection(selected: true)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselectItemAt")
        if collectionView == campusCollectionView {
            selectedCampusLocations.removeAll { $0 == campusLocations[indexPath.row] }
        } else {
            selectedCtownLocations.removeAll { $0 == ctownLocations[indexPath.row] }
        }
        print( (collectionView.cellForItem(at: indexPath) as? SchedulingCollectionViewCell))
        (collectionView.cellForItem(at: indexPath) as? SchedulingCollectionViewCell)?.changeSelection(selected: false)
    }

}

extension SchedulingPlacesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == campusCollectionView ? campusLocations.count : ctownLocations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isCampus = collectionView == campusCollectionView
        let collection = isCampus ? campusCollectionView : ctownCollectionView
        let reuseID = isCampus ? campusReuseIdentifier : ctownReuseIdentiifier
        let location = (isCampus ? campusLocations : ctownLocations)[indexPath.row] // TODO check this
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as?
            SchedulingCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: location)
        return cell

    }

}
