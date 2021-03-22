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
        headerLabel.alpha = 0
        headerLabel.font = ._24CircularStdMedium
        view.addSubview(headerLabel)

        closeButton.setImage(UIImage(named: "cancelled"), for: .normal)
        closeButton.addTarget(self, action: #selector(finishFeedback), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)

        questionLabel.text = "Did you meet your last Pear?"
        questionLabel.textColor = .black
        questionLabel.alpha = 0
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
        answerCollectionView.alpha = 0
        answerCollectionView.register(FeedbackCollectionViewCell.self, forCellWithReuseIdentifier: FeedbackCollectionViewCell.reuseIdentifier)
        view.addSubview(answerCollectionView)

        finishButton.setTitle("Finish", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.titleLabel?.font = ._20CircularStdBold
        finishButton.backgroundColor = .backgroundOrange
        finishButton.layer.cornerRadius = 26
        finishButton.addTarget(self, action: #selector(finishFeedback), for: .touchUpInside)
        finishButton.alpha = 0
        view.addSubview(finishButton)

        lowRatingLabel.text = "Not so fun"
        lowRatingLabel.font = ._12CircularStdBook
        lowRatingLabel.textColor = .greenGray
        lowRatingLabel.alpha = 0
        view.addSubview(lowRatingLabel)

        highRatngLabel.text = "Had a blast"
        highRatngLabel.font = ._12CircularStdBook
        highRatngLabel.textColor = .greenGray
        highRatngLabel.alpha = 0
        view.addSubview(highRatngLabel)

        askDetailLabel.text = "Want to share why?"
        askDetailLabel.textColor = .black
        askDetailLabel.alpha = 0
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
        detailTextView.alpha = 0
        view.addSubview(detailTextView)

        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimation()
    }

    private func animateView(duration: Double, delay: Double, previousY: CGFloat, yOffset: CGFloat, animateView: UIView) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            animateView.alpha = 1
            animateView.center.y = previousY + yOffset
        })
    }

    private func setupAnimation() {
        headerLabel.center.y = UIScreen.main.bounds.height
        questionLabel.center.y = UIScreen.main.bounds.height
        answerCollectionView.center.y = UIScreen.main.bounds.height
        animateView(duration: 0.4, delay: 0, previousY: 160, yOffset: 0, animateView: headerLabel)
        animateView(duration: 0.4, delay: 0.4, previousY: headerLabel.center.y, yOffset: 120, animateView: questionLabel)
        animateView(duration: 0.4, delay: 0.8, previousY: questionLabel.center.y, yOffset: 110, animateView: answerCollectionView)
    }

    private func removeInitialAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.questionLabel.alpha = 0
            self.questionLabel.center.y = 240
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.answerCollectionView.alpha = 0
                self.answerCollectionView.center.y = 240
            }, completion: { _ in
                self.feedbackStatus == .didNotMeet ? self.notMeetAnimation() : self.didMeetAnimation()
            })
        }
    }

    private func notMeetAnimation() {
        questionLabel.text = "Aww, why didn’t you meet?"
        questionLabel.center.y = screenHeight
        answerCollectionView.center.y = screenHeight
        finishButton.center.y = screenHeight
        feedbackOptions = didNotMeetFeedbackOptions
        answerCollectionView.allowsMultipleSelection = true
        DispatchQueue.main.async {
            self.answerCollectionView.reloadData()
        }
        animateView(duration: 0.4, delay: 0, previousY: self.headerLabel.center.y, yOffset: 120, animateView: questionLabel)
        animateView(duration: 0.4, delay: 0.4, previousY: self.questionLabel.center.y, yOffset: 110, animateView: answerCollectionView)
        animateView(duration: 0.6, delay: 0.8, previousY: finishButtonY, yOffset: 0, animateView: finishButton)
    }

    private func didMeetAnimation() {
        questionLabel.text = "Yay! How did your chat go?"
        questionLabel.center.y = screenHeight
        answerCollectionView.center.y = screenHeight
        finishButton.center.y = screenHeight
        lowRatingLabel.center.y = screenHeight
        highRatngLabel.center.y = screenHeight
        askDetailLabel.center.y = screenHeight
        detailTextView.center.y = screenHeight
        feedbackOptions = didMeetFeedbackOptions
        DispatchQueue.main.async {
            self.answerCollectionView.reloadData()
        }
        answerCollectionView.snp.remakeConstraints { make in
            make.width.equalTo(260)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(questionLabel.snp.centerY).offset(110)
            make.bottom.equalTo(view.snp.centerY)
        }
        animateView(duration: 0.4, delay: 0, previousY: headerLabel.center.y, yOffset: 120, animateView: questionLabel)
        animateView(duration: 0.4, delay: 0.4, previousY: questionLabel.center.y, yOffset: 110, animateView: answerCollectionView)
        animateView(duration: 0.4, delay: 0.8, previousY: answerCollectionView.center.y, yOffset: -5, animateView: lowRatingLabel)
        animateView(duration: 0.4, delay: 0.8, previousY: answerCollectionView.center.y, yOffset: -5, animateView: highRatngLabel)
        animateView(duration: 0.4, delay: 1.2, previousY: lowRatingLabel.center.y, yOffset: 80, animateView: askDetailLabel)
        animateView(duration: 0.4, delay: 1.6, previousY: askDetailLabel.center.y, yOffset: 60, animateView: detailTextView)
        animateView(duration: 0.6, delay: 2.0, previousY: finishButtonY, yOffset: 0, animateView: finishButton)
    }

    @objc private func finishFeedback() {
        print(responses)
    }

    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.top.equalToSuperview().offset(110)
        }

        questionLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerLabel.snp.leading)
            make.top.equalTo(headerLabel.snp.bottom).offset(60)
        }

        answerCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.centerY.equalTo(questionLabel.snp.centerY).offset(110)
            make.bottom.equalTo(view.snp.centerY)
        }

        finishButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }

        lowRatingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(answerCollectionView.snp.left)
            make.centerY.equalTo(answerCollectionView.snp.centerY)
        }

        highRatngLabel.snp.makeConstraints { make in
            make.centerX.equalTo(answerCollectionView.snp.right)
            make.centerY.equalTo(lowRatingLabel.snp.centerY)
        }

        askDetailLabel.snp.makeConstraints { make in
            make.leading.equalTo(questionLabel.snp.leading)
            make.centerY.equalTo(lowRatingLabel.snp.centerY).offset(80)
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
            removeInitialAnimation()
        case .didNotMeet, .didMeet:
            responses.append(feedbackOptions[indexPath.section][indexPath.row].text)
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
