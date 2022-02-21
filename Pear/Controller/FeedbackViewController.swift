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
    private let backButton = UIButton()
    private let closeButton = UIButton()
    private let detailTextView = UITextView()
    private let finishButton = FinishButton()
    private let headerLabel = UILabel()
    private let highRatingLabel = UILabel()
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
    private var matchId: Int
    private var feedbackOptions: [[FeedbackOption]] = []
    private var feedbackStatus: FeedbackStatus = .initial
    private var responses: [String] = []
    
    init(matchId: Int) {
        self.matchId = matchId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFill
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.isHidden = true
        view.addSubview(backButton)

        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFill
        closeButton.addTarget(self, action: #selector(quitFeedback), for: .touchUpInside)
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
        finishButton.isEnabled = false
        finishButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2
        finishButton.addTarget(self, action: #selector(finishFeedback), for: .touchUpInside)
        finishButton.isHidden = true
        view.addSubview(finishButton)

        lowRatingLabel.text = "Not so fun"
        lowRatingLabel.font = ._12CircularStdBook
        lowRatingLabel.textColor = .greenGray
        lowRatingLabel.isHidden = true
        view.addSubview(lowRatingLabel)

        highRatingLabel.text = "Had a blast"
        highRatingLabel.font = ._12CircularStdBook
        highRatingLabel.textColor = .greenGray
        highRatingLabel.isHidden = true
        view.addSubview(highRatingLabel)
        
        let askDetailLabelText = NSMutableAttributedString(string: "Want to share why? (Optional)")
        askDetailLabelText.setColor(color: .inactiveGreen, forText: "(Optional)")
        askDetailLabel.attributedText = askDetailLabelText
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
        
        dismissKeyboard()
        setupConstraints()
    }
    
    func dismissKeyboard() {
           let tap = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboardTouchOutside))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
    }
        
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }

    @objc private func finishFeedback() {
        let didMeet = responses[0] == "Yes"
        let rating = Int(responses[1])
        let reasonsNo = Array(responses[1...])
        NetworkManager.sendFeedback(matchId: matchId, didMeet: didMeet, rating: rating, didMeetReason: detailTextView.text, didNotMeetReasons: reasonsNo) { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                }
            }
        }
    }
    
    @objc private func quitFeedback() {
        NetworkManager.quitFeedback() { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                }
            }
        }
    }
    
    @objc private func goBack() {
        backButton.isHidden = true
        finishButton.isHidden = true
        finishButton.isEnabled = false
        responses = []
        detailTextView.text = ""
        questionLabel.text = "Did you meet your last Pear?"
        feedbackOptions = initialFeedbackOptions
        feedbackStatus = .initial
        answerCollectionView.allowsMultipleSelection = false
        lowRatingLabel.isHidden = true
        highRatingLabel.isHidden = true
        askDetailLabel.isHidden = true
        detailTextView.isHidden = true
        answerCollectionView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.height.equalTo(200)
        }
        DispatchQueue.main.async {
            self.answerCollectionView.reloadData()
        }
    }

    private func setupAdditionalResponse() {
        backButton.isHidden = false
        finishButton.isHidden = false
        if feedbackStatus == .didNotMeet {
            questionLabel.text = "Aww, why didn't you meet?"
            feedbackOptions = didNotMeetFeedbackOptions
            answerCollectionView.allowsMultipleSelection = true
        } else {
            questionLabel.text = "Yay! How did your chat go?"
            feedbackOptions = didMeetFeedbackOptions
            lowRatingLabel.isHidden = false
            highRatingLabel.isHidden = false
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
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(40)
            make.centerY.equalTo(backButton)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }

        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.top.equalTo(closeButton.snp.bottom).offset(36)
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

        highRatingLabel.snp.makeConstraints { make in
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
            finishButton.isEnabled = true
        }
        print(responses)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        responses.removeAll { $0 == feedbackOptions[indexPath.section][indexPath.row].text }
        finishButton.isEnabled = responses != [initialFeedbackOptions[0][1].text]
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

private class FinishButton: UIButton {
    
    override public var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .backgroundOrange : .inactiveGreen
            }
    }
    
}
