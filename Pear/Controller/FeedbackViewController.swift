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
    private let closeButton = UIButton()
    private let headerLabel = UILabel()
    private let questionLabel = UILabel()
    private var answerCollectionView: UICollectionView!
    private let lowRatingLabel = UILabel()
    private let highRatngLabel = UILabel()
    private let askDetailLabel = UILabel()
    private let detailTextView = UITextView()
    private let finishButton = UIButton()

    // MARK: - Private Data Vars
    private let collectionViewSpacing: CGFloat = 12
    private let initialFeedbackOptions: [[FeedbackOption]] = [
        [FeedbackOption(text: "Yes", image: "schedule", hasImage: true, isRating: false),
         FeedbackOption(text: "No", image: "cancelled", hasImage: true, isRating: false)]
    ]
    private let didNotMeetFeedbackOptions: [[FeedbackOption]] = [
        [FeedbackOption(text: "Not a good fit", image: "", hasImage: false, isRating: false),
         FeedbackOption(text: "They didn't respond", image: "", hasImage: false, isRating: false)],
        [FeedbackOption(text: "Not interested", image: "", hasImage: false, isRating: false),
         FeedbackOption(text: "Too busy", image: "", hasImage: false, isRating: false),
         FeedbackOption(text: "Other", image: "", hasImage: false, isRating: false)]
    ]
    private let didMeetFeedbackOptions: [[FeedbackOption]] = [
        [FeedbackOption(text: "1", image: "", hasImage: false, isRating: true),
         FeedbackOption(text: "2", image: "", hasImage: false, isRating: true),
         FeedbackOption(text: "3", image: "", hasImage: false, isRating: true),
         FeedbackOption(text: "4", image: "", hasImage: false, isRating: true),
         FeedbackOption(text: "5", image: "", hasImage: false, isRating: true)
        ]
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
        closeButton.addTarget(self, action: #selector(closeFeedback), for: .touchUpInside)
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
        }, completion: nil)
    }

    private func setupAnimation() {
        headerLabel.center.y = UIScreen.main.bounds.height
        questionLabel.center.y = UIScreen.main.bounds.height
        answerCollectionView.center.y = UIScreen.main.bounds.height

        animateView(duration: 0.4, delay: 0, previousY: 160, yOffset: 0, animateView: headerLabel)
//        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
//            self.headerLabel.alpha = 1
//            self.headerLabel.center.y = 160
//        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.questionLabel.alpha = 1
            self.questionLabel.center.y = self.headerLabel.center.y + 120
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.8, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.answerCollectionView.alpha = 1
            self.answerCollectionView.center.y = self.questionLabel.center.y + 110
        }, completion: nil)
    }

    private func removeInitialAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.questionLabel.alpha = 0
            self.questionLabel.center.y = 160
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.answerCollectionView.alpha = 0
                self.answerCollectionView.center.y = 0
            }, completion: { _ in
                self.feedbackStatus == .didNotMeet ? self.notMeetAnimation() : self.didMeetAnimation()
            })
        }
    }

    private func notMeetAnimation() {
        questionLabel.text = "Aww, why didn’t you meet?"
        let screenHeight = UIScreen.main.bounds.height
        questionLabel.center.y = screenHeight
        answerCollectionView.center.y = screenHeight
        finishButton.center.y = screenHeight
        feedbackOptions = didNotMeetFeedbackOptions
        answerCollectionView.allowsMultipleSelection = true
        DispatchQueue.main.async {
            self.answerCollectionView.reloadData()
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.questionLabel.alpha = 1
            self.questionLabel.center.y = self.headerLabel.center.y + 120
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.answerCollectionView.alpha = 1
            self.answerCollectionView.center.y = self.questionLabel.center.y + 110
        }, completion: nil)
        UIView.animate(withDuration: 0.6, delay: 0.8, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.finishButton.alpha = 1
            self.finishButton.center.y = screenHeight - Constants.Onboarding.nextBottomPadding - (Constants.Onboarding.mainButtonSize.height / 2)
        }, completion: nil)
    }

    private func didMeetAnimation() {
        questionLabel.text = "Yay! How did your chat go?"
        let screenHeight = UIScreen.main.bounds.height
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
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.questionLabel.alpha = 1
            self.questionLabel.center.y = self.headerLabel.center.y + 120
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.answerCollectionView.alpha = 1
            self.answerCollectionView.center.x = self.view.center.x
            self.answerCollectionView.center.y = self.questionLabel.center.y + 110
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.8, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.lowRatingLabel.alpha = 1
            self.highRatngLabel.alpha = 1
            self.lowRatingLabel.center.y = self.answerCollectionView.center.y - 5
            self.highRatngLabel.center.y = self.answerCollectionView.center.y - 5
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 1.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.askDetailLabel.alpha = 1
            self.askDetailLabel.center.y = self.lowRatingLabel.center.y + 80
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 1.6, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.detailTextView.alpha = 1
            self.detailTextView.center.y = self.askDetailLabel.center.y + 60
        }, completion: nil)
        UIView.animate(withDuration: 0.6, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.finishButton.alpha = 1
            self.finishButton.center.y = screenHeight - Constants.Onboarding.nextBottomPadding - (Constants.Onboarding.mainButtonSize.height / 2)
        }, completion: nil)
    }

    @objc private func closeFeedback() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func finishFeedback() {
        print("finish feedback")
        responses.append(detailTextView.text)
        print(responses)
        self.dismiss(animated: true, completion: nil)
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
            make.left.equalTo(questionLabel.snp.left)
            make.centerY.equalTo(lowRatingLabel.snp.centerY).offset(80)
        }

        detailTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(36)
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
