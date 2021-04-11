//
//  FeedbackViewController.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

// MARK: - FeedbackStatus

/// The status the user is currently at in responding to the feedback
enum FeedbackStatus {
    /// The user is answering whether or not they met their last pear
    case initial
    /// The user answered they did not meet their last pear
    case didNotMeet
    /// The user answered they did meet their last pear
    case didMeet
}

class FeedbackViewController: UIViewController {

    // MARK: - Private View Vars
    private var answerCollectionView: UICollectionView!
    private let askDetailLabel = UILabel()
    private let closeButton = UIButton()
    private let detailTextView = UITextView()
    private let finishButton = UIButton()
    private let headerLabel = UILabel()
    private let highRatngLabel = UILabel()
    private let lowRatingLabel = UILabel()
    private let questionLabel = UILabel()

    // MARK: - Private Data Vars
    private let screenHeight = UIScreen.main.bounds.height
    private let finishButtonY = UIScreen.main.bounds.height - Constants.Onboarding.nextBottomPadding - (Constants.Onboarding.mainButtonSize.height / 2)
    private let collectionViewSpacing: CGFloat = 12
    private let initialFeedbackOptions: [[FeedbackOption]] = [
        [FeedbackOption(hasImage: true, image: "schedule", isRating: false, text: "Yes"),
        FeedbackOption(hasImage: true, image: "cancelled", isRating: false, text: "No")]
    ]
    private let didNotMeetFeedbackOptions: [[FeedbackOption]] = [
        [FeedbackOption(hasImage: false, image: "", isRating: false, text: "Not a good fit"),
         FeedbackOption(hasImage: false, image: "", isRating: false, text: "They didn't respond")],
        [FeedbackOption(hasImage: false, image: "", isRating: false, text: "Not interested"),
         FeedbackOption(hasImage: false, image: "", isRating: false, text: "Too busy"),
         FeedbackOption(hasImage: false, image: "", isRating: false, text: "Other")]
    ]
    private let didMeetFeedbackOptions: [[FeedbackOption]] = [
        [FeedbackOption(hasImage: false, image: "", isRating: true, text: "1"),
         FeedbackOption(hasImage: false, image: "", isRating: true, text: "2"),
         FeedbackOption(hasImage: false, image: "", isRating: true, text: "3"),
         FeedbackOption(hasImage: false, image: "", isRating: true, text: "4"),
         FeedbackOption(hasImage: false, image: "", isRating: true, text: "5")]
    ]
    private var feedbackOptions: [[FeedbackOption]] = []
    private var feedbackStatus: FeedbackStatus = .initial
    private var responses: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.shadowImage = UIImage()

        feedbackOptions = initialFeedbackOptions

        headerLabel.text = "I’m so glad you’re back! But\nfirst, a few quick\nquestions..."
        headerLabel.textColor = .black
        headerLabel.numberOfLines = 0
        headerLabel.font = ._24CircularStdMedium
        view.addSubview(headerLabel)

        closeButton.setImage(UIImage(named: "cancelled"), for: .normal)
        closeButton.addTarget(self, action: #selector(finishFeedback), for: .touchUpInside)
        view.addSubview(closeButton)

        questionLabel.text = "Did you meet your last Pear?"
        questionLabel.textColor = .black
        questionLabel.font = ._20CircularStdBook
        view.addSubview(questionLabel)

        let answerCollectionViewLayout = UICollectionViewFlowLayout()
        answerCollectionViewLayout.minimumLineSpacing = collectionViewSpacing
        answerCollectionViewLayout.minimumInteritemSpacing = collectionViewSpacing
        answerCollectionViewLayout.sectionInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 0.0, right: 0.0)

        answerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: answerCollectionViewLayout)
        answerCollectionView.allowsMultipleSelection = false
        answerCollectionView.showsVerticalScrollIndicator = false
        answerCollectionView.showsHorizontalScrollIndicator = false
        answerCollectionView.delegate = self
        answerCollectionView.dataSource = self
        answerCollectionView.backgroundColor = .clear
        answerCollectionView.layer.masksToBounds = false
        answerCollectionView.register(FeedbackCollectionViewCell.self, forCellWithReuseIdentifier: FeedbackCollectionViewCell.reuseIdentifier)
        view.addSubview(answerCollectionView)

        finishButton.setTitle("Finish", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.titleLabel?.font = ._20CircularStdBold
        finishButton.backgroundColor = .backgroundOrange
        finishButton.layer.cornerRadius = 26
        finishButton.addTarget(self, action: #selector(finishFeedback), for: .touchUpInside)
        finishButton.isHidden = true
        view.addSubview(finishButton)

        lowRatingLabel.text = "Not so fun"
        lowRatingLabel.font = ._12CircularStdBook
        lowRatingLabel.textColor = .greenGray
        lowRatingLabel.isHidden = true
        view.addSubview(lowRatingLabel)

        highRatngLabel.text = "Had a blast"
        highRatngLabel.font = ._12CircularStdBook
        highRatngLabel.textColor = .greenGray
        highRatngLabel.isHidden = true
        view.addSubview(highRatngLabel)

        askDetailLabel.text = "Want to share why?"
        askDetailLabel.textColor = .black
        askDetailLabel.isHidden = true
        askDetailLabel.font = ._20CircularStdBook
        view.addSubview(askDetailLabel)

        detailTextView.clipsToBounds = false
        detailTextView.layer.cornerRadius = 12
        detailTextView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        detailTextView.layer.shadowOpacity = 1
        detailTextView.layer.shadowRadius = 4
        detailTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
        detailTextView.font = ._16CircularStdBook
        detailTextView.isEditable = true
        detailTextView.isHidden = true
        view.addSubview(detailTextView)

        setupConstraints()
    }
    
    @objc private func finishFeedback() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        responses.append(detailTextView.text)
        NetworkManager.shared.getMatchHistory(netID: netId).observe { response in
            switch response {
            case .value(let value):
                UserDefaults.standard.setValue(value.data.count, forKey: Constants.UserDefaults.previousMatchHistorySize)
            case .error(let error):
                print(error)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    private func setupAdditionalResponse() {
        finishButton.isHidden = false
        if feedbackStatus == .didNotMeet {
            questionLabel.text = "Aww, why didn't you meet?"
            feedbackOptions = didNotMeetFeedbackOptions
            answerCollectionView.allowsMultipleSelection = true
        } else {
            questionLabel.text = "Yay! How did your chat go?"
            feedbackOptions = didMeetFeedbackOptions
            lowRatingLabel.isHidden = false
            highRatngLabel.isHidden = false
            askDetailLabel.isHidden = false
            detailTextView.isHidden = false
            answerCollectionView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(questionLabel.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview().inset(80)
                make.height.equalTo(50)
            }
        }
        DispatchQueue.main.async {
            self.answerCollectionView.reloadData()
        }
    }

    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(36)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(25)
        }

        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.top.equalToSuperview().offset(110)
        }

        questionLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerLabel.snp.leading)
            make.top.equalTo(headerLabel.snp.bottom).offset(50)
        }

        answerCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.height.equalTo(200)
        }

        finishButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }

        lowRatingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(answerCollectionView.snp.left).inset(12)
            make.top.equalTo(answerCollectionView.snp.bottom).offset(10)
        }

        highRatngLabel.snp.makeConstraints { make in
            make.centerX.equalTo(answerCollectionView.snp.right).inset(12)
            make.top.equalTo(lowRatingLabel)
        }

        askDetailLabel.snp.makeConstraints { make in
            make.leading.equalTo(questionLabel.snp.leading)
            make.top.equalTo(lowRatingLabel.snp.bottom).offset(30)
        }

        detailTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(70)
            make.centerY.equalTo(askDetailLabel.snp.centerY).offset(60)
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension FeedbackViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if feedbackStatus == .didNotMeet {
            return 2
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedbackOptions[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedback: FeedbackOption
        switch feedbackStatus {
        case .initial, .didNotMeet:
            guard let cell = answerCollectionView.dequeueReusableCell(withReuseIdentifier: FeedbackCollectionViewCell.reuseIdentifier, for: indexPath) as? FeedbackCollectionViewCell else { return UICollectionViewCell() }
            feedback = feedbackOptions[indexPath.section][indexPath.row]
            cell.configure(for: feedback)
            return cell
        case .didMeet:
            guard let cell = answerCollectionView.dequeueReusableCell(withReuseIdentifier: FeedbackCollectionViewCell.reuseIdentifier, for: indexPath) as? FeedbackCollectionViewCell else { return UICollectionViewCell() }
            feedback = feedbackOptions[indexPath.section][indexPath.row]
            cell.configure(for: feedback)
            return cell
        }
    }

}

extension FeedbackViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch feedbackStatus {
        case .initial:
            let selected = feedbackOptions[indexPath.section][indexPath.row].text
            feedbackStatus = selected == "Yes" ? .didMeet : .didNotMeet
            responses.append(selected)
            setupAdditionalResponse()
        case .didNotMeet, .didMeet:
            let selectedResponse = feedbackOptions[indexPath.section][indexPath.row].text
            if (!responses.contains(selectedResponse)) {
                responses.append(feedbackOptions[indexPath.section][indexPath.row].text)
            }
        }
        print(responses)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        responses.removeAll { $0 == feedbackOptions[indexPath.section][indexPath.row].text }
        print(responses)
    }

}

extension FeedbackViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if feedbackOptions[indexPath.section][indexPath.row].isRating {
            return CGSize(width: 36, height: 36)
        }
        let label = UILabel(frame: .zero)
        label.text = feedbackOptions[indexPath.section][indexPath.row].text
        label.sizeToFit()
        let width = label.frame.width + 35
        let height = label.frame.height + 10

        switch feedbackStatus {
        case .initial:
            return CGSize(width: width + 20, height: height)
        case .didNotMeet, .didMeet:
            return CGSize(width: width - 20, height: height)
        }
    }

}
