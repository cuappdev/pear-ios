//
//  PausePearView.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/15/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

enum PauseTime: String {
    case oneWeek = "1 Week"
    case twoWeeks = "2 Weeks"
    case threeWeeks = "3 Weeks"
    case indefinitely = "Indefinitely"
    
    func getTitle() -> String {
        return self.rawValue
    }
}

class PausePearView: UIView {

    // MARK: - Private View Vars
    private let pauseLabel = UILabel()
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    private var timeCollectionView: UICollectionView!

    // MARK: - Private Data Vars
    private weak var delegate: PausePearDelegate?
    private var selectedState: String = ""
    private let timeInteritemSpacing: CGFloat = 11
    private let pauseTimes: [PauseTime] = [.oneWeek, .twoWeeks, .threeWeeks, .indefinitely]
    
    init(delegate: PausePearDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setUpViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        backgroundColor = .backgroundLightGreen
        layer.cornerRadius = 36
        frame.size = CGSize(width: 295, height: 422)
        
        let timeCollectionViewLayout = UICollectionViewFlowLayout()
        timeCollectionViewLayout.minimumInteritemSpacing = timeInteritemSpacing
        timeCollectionViewLayout.scrollDirection = .vertical
        
        timeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timeCollectionViewLayout)
        timeCollectionView.allowsMultipleSelection = false
        timeCollectionView.backgroundColor = .clear
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.register(SchedulingTimeCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingTimeCollectionViewCell.reuseIdentifier)
        addSubview(timeCollectionView)

        pauseLabel.text = "Pause Pear for..."
        pauseLabel.font = ._20CircularStdBook
        pauseLabel.textAlignment = .center
        pauseLabel.textColor = .black
        addSubview(pauseLabel)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = ._16CircularStdMedium
        saveButton.backgroundColor = .inactiveGreen
        saveButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2.2
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        addSubview(saveButton)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.darkGreen, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = ._16CircularStdBold
        cancelButton.addTarget(self, action: #selector(cancelPause), for: .touchUpInside)
        addSubview(cancelButton)
        
    }

    private func setButtonAppearance(button: UIButton) {
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = ._16CircularStdBook
    }

    private func setupConstraints() {
        let cancelButtonSize = CGSize(width: 52, height: 20)
        let saveButtonSize = CGSize(width: 195, height: 46)

        pauseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(36)
            make.leading.trailing.equalToSuperview().inset(75)
        }

        timeCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pauseLabel.snp.bottom).offset(26)
            make.height.equalTo(177)
            make.width.equalTo(135)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeCollectionView.snp.bottom).offset(26)
            make.size.equalTo(saveButtonSize)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.size.equalTo(cancelButtonSize)
        }
    }
    
    private func updateSave() {
        saveButton.isEnabled = selectedState != ""
        if saveButton.isEnabled {
            saveButton.backgroundColor = .backgroundOrange
            saveButton.layer.shadowColor = UIColor.black.cgColor
            saveButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            saveButton.layer.shadowOpacity = 0.15
            saveButton.layer.shadowRadius = 2
        } else {
            saveButton.backgroundColor = .inactiveGreen
            saveButton.layer.shadowColor = .none
            saveButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            saveButton.layer.shadowOpacity = 0
            saveButton.layer.shadowRadius = 0
        }
    }
    
    @objc private func saveButtonPressed() {
        delegate?.removePauseView(self)
        guard let pauseDelegate = delegate else {return}
        let pauseFinishView = PausePearFinishView(delegate: pauseDelegate)
        delegate?.presentPauseView(pauseFinishView)
    }
    
    @objc private func cancelPause() {
        delegate?.removePauseView(self)
        delegate?.removeBlurEffect()
    }

}

extension PausePearView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pauseTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SchedulingTimeCollectionViewCell.reuseIdentifier,
                for: indexPath
        ) as? SchedulingTimeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(for: pauseTimes[indexPath.row].getTitle(), isHeader: false)
        return cell
    }
}

extension PausePearView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedState = pauseTimes[indexPath.row].getTitle()
        updateSave()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedState = ""
        updateSave()
    }
}

extension PausePearView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135, height: 36)
       
    }
}
