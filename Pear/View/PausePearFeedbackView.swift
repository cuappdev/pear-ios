//
//  PausePearFeedbackView.swift
//  Pear
//
//  Created by Vian Nguyen on 3/2/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class PausePearFeedbackView: UIView {

    // MARK: - Private View Vars
    private let pauseLabel = UILabel()
    private let finishButton = UIButton()
    private let cancelButton = UIButton()
    private var pauseReasonCollectionView: UICollectionView!

    // MARK: - Private Data Vars
    private weak var delegate: PausePearDelegate?
    private var selectedReason: String = ""
    private let reasonInteritemSpacing: CGFloat = 11
    private let pauseReasons: [String] = ["Focusing on work", "Won't be on campus", "Bad experience", "Other"]
    
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
        self.backgroundColor = .backgroundLightGreen
        self.layer.cornerRadius = 36
        frame.size = CGSize(width: 295, height: 422)
        
        let pauseReasonCollectionViewLayout = UICollectionViewFlowLayout()
        pauseReasonCollectionViewLayout.minimumInteritemSpacing = reasonInteritemSpacing
        pauseReasonCollectionViewLayout.scrollDirection = .vertical
        
        pauseReasonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: pauseReasonCollectionViewLayout)
        pauseReasonCollectionView.allowsMultipleSelection = false
        pauseReasonCollectionView.backgroundColor = .clear
        pauseReasonCollectionView.dataSource = self
        pauseReasonCollectionView.delegate = self
        pauseReasonCollectionView.register(SchedulingTimeCollectionViewCell.self, forCellWithReuseIdentifier: SchedulingTimeCollectionViewCell.reuseIdentifier)
        addSubview(pauseReasonCollectionView)

        pauseLabel.text = "Why are you pausing?"
        pauseLabel.font = ._20CircularStdBook
        pauseLabel.textAlignment = .center
        pauseLabel.textColor = .black
        addSubview(pauseLabel)
        
        finishButton.setTitle("Finish", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.titleLabel?.font = ._16CircularStdMedium
        finishButton.backgroundColor = .inactiveGreen
        finishButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2.2
        finishButton.isEnabled = false
        finishButton.addTarget(self, action: #selector(finishButtonPressed), for: .touchUpInside)
        addSubview(finishButton)

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
        let finishButtonSize = CGSize(width: 195, height: 46)
        let pauseLabelSize = CGSize(width: 200, height: 25)
        let reasonCollectionViewSize = CGSize(width: 191, height: 177)

        pauseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(36)
            make.size.equalTo(pauseLabelSize)
        }

        pauseReasonCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pauseLabel.snp.bottom).offset(26)
            make.size.equalTo(reasonCollectionViewSize)
        }
        
        finishButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pauseReasonCollectionView.snp.bottom).offset(26)
            make.size.equalTo(finishButtonSize)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(finishButton.snp.bottom).offset(20)
            make.size.equalTo(cancelButtonSize)
        }
    }
    
    private func updateFinish() {
        finishButton.isEnabled = selectedReason != ""
        if finishButton.isEnabled {
            finishButton.backgroundColor = .backgroundOrange
            finishButton.layer.shadowColor = UIColor.black.cgColor
            finishButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            finishButton.layer.shadowOpacity = 0.15
            finishButton.layer.shadowRadius = 2
        } else {
            finishButton.backgroundColor = .inactiveGreen
            finishButton.layer.shadowColor = .none
            finishButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            finishButton.layer.shadowOpacity = 0
            finishButton.layer.shadowRadius = 0
        }
    }
    
    @objc private func finishButtonPressed() {
        delegate?.removePauseView(self)
        delegate?.removeBlurEffect()
        // TODO: send user feedback
    }
    
    @objc private func cancelPause() {
        delegate?.removePauseView(self)
        delegate?.removeBlurEffect()
    }

}

extension PausePearFeedbackView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pauseReasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SchedulingTimeCollectionViewCell.reuseIdentifier,
                for: indexPath
        ) as? SchedulingTimeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(for: pauseReasons[indexPath.row], isHeader: false)
        return cell
    }
}

extension PausePearFeedbackView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedReason = pauseReasons[indexPath.row]
        updateFinish()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedReason = ""
        updateFinish()
    }
}

extension PausePearFeedbackView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 191, height: 36)
       
    }
}
