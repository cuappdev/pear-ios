//  MeetupStatusView.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 9/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class MeetupStatusView: UIView {

    // - MARK: Private View Vars
    private let backgroundShadingView = UIView()
    private let messageTextView = UITextView()
    private let pearImageView = UIImageView()
    private let statusImageView = UIImageView()
    private let statusLabel = UILabel()

    // - MARK: Spacing Vars
    private let messageLeadingPadding: CGFloat = 12
    private let messageTrailingPadding: CGFloat = 8
    private let messageVerticalPadding: CGFloat = 8
    private let pearImageSize = CGSize(width: 40, height: 40)
    private let pearPadding: CGFloat = 8
    private let statusImageSize = CGSize(width: 10, height: 10)
    private let statusMessagePadding: CGFloat = 6.5

    convenience init?(for status: ChatStatus) {
        self.init()

        switch status {
        case .respondingTo(let user):
            setupForResponding(to: user)
        case .waitingOn(let user):
            setupForWaiting(for: user)
        case .chatScheduled(let user, let date):
            if Time.isTommorow(date) {
                setupForDayBeforeMeeting(on: date)
            } else {
                setupForChatScheduled(on: date, for: user)
            }
        case .cancelled(let user):
            setupForChatCancelled(with: user)
        case .noResponses:
            setupForNoResponses()
        case .finished:
            setupForChatFinished()
        default:
            print("There is no meetupStatusView for \(status) so returning nil")
            return nil
        }
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Returns the height required for this view to display the text without overflowing
    public func getRecommendedHeight(for width: CGFloat) -> CGFloat {
        let textWidth = width - pearImageSize.width - messageLeadingPadding - messageTrailingPadding - pearPadding
        let verticalSpace = 2 * messageVerticalPadding + statusMessagePadding + statusImageSize.height
        if let attributedText = messageTextView.attributedText {
            return attributedText.height(containerWidth: textWidth) + verticalSpace
        } else {
            return 0
        }
    }

    private func setupViews() {
        backgroundShadingView.backgroundColor = .backgroundLightGrayGreen
        backgroundShadingView.layer.cornerRadius = 12
        addSubview(backgroundShadingView)

        statusLabel.textColor = .textGreen
        statusLabel.font = ._12CircularStdMedium
        statusLabel.numberOfLines = 0
        addSubview(statusLabel)

        statusImageView.contentMode = .scaleAspectFit
        addSubview(statusImageView)

        messageTextView.backgroundColor = .clear
        messageTextView.contentInset = .zero
        messageTextView.contentInsetAdjustmentBehavior = .never
        messageTextView.font = UIFont._16CircularStdMedium
        messageTextView.isEditable = false
        messageTextView.isScrollEnabled = false
        messageTextView.showsHorizontalScrollIndicator = false
        messageTextView.showsVerticalScrollIndicator = false
        messageTextView.textColor = .black
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = .zero
        messageTextView.tintColor = .textGreen
        backgroundShadingView.addSubview(messageTextView)

        pearImageView.image = UIImage(named: "happyPear")
        pearImageView.layer.cornerRadius = pearImageSize.width / 2
        pearImageView.layer.shadowColor = UIColor.black.cgColor
        pearImageView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        pearImageView.layer.shadowOpacity = 0.15
        pearImageView.layer.shadowRadius = 2
        backgroundShadingView.addSubview(pearImageView)
    }

    private func setupConstraints() {
        statusImageView.snp.makeConstraints { make in
            make.size.equalTo(statusImageSize)
            make.leading.equalToSuperview()
            make.centerY.equalTo(statusLabel)
        }

        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusImageView.snp.trailing).offset(4)
            make.top.equalToSuperview()
        }

        backgroundShadingView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(statusMessagePadding)
            make.leading.trailing.bottom.equalToSuperview()
        }

        pearImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(pearPadding)
            make.size.equalTo(pearImageSize)
        }

        messageTextView.snp.makeConstraints { make in
            make.leading.equalTo(pearImageView.snp.trailing).offset(messageLeadingPadding)
            make.top.bottom.equalToSuperview().inset(messageVerticalPadding)
            make.trailing.equalToSuperview().inset(messageTrailingPadding)
        }
    }

    // MARK: Different View States

    private func setupForResponding(to user: User) {
        statusImageView.image = UIImage(named: "newPear")
        statusLabel.text = "New Pear"
        messageTextView.attributedText = NSMutableAttributedString()
            .normalFont("\(user.firstName) wants to meet you! Pick a time that works for both of you.")
    }

    private func setupForWaiting(for user: User) {
        statusImageView.image = UIImage(named: "reachedOut")
        statusLabel.text = "Reached out"
        messageTextView.attributedText = NSMutableAttributedString()
            .normalFont("Just waiting on \(user.firstName) to pick a time and place!")
    }

    private func setupForChatScheduled(on date: Date, for user: User) {
        statusImageView.image = UIImage(named: "scheduled")
        statusLabel.text = "Chat scheduled"

        let fullText = NSMutableAttributedString()
            .normalFont("Get pumped to meet on ")
            .underlinedFont("\(formatDate(date))")
            .normalFont(".")

        if user.instagram != nil || user.facebook != nil {
            fullText
                .normalFont("\nYou can reach \(user.firstName) on ")
                .socialMediaLinks(instagram: user.instagram, facebook: user.facebook)
                .normalFont(".")
        }

        messageTextView.attributedText = fullText
    }

    private func setupForDayBeforeMeeting(on date: Date) {
        statusImageView.image = UIImage(named: "scheduled")
        statusLabel.text = "Chatting soon"
        messageTextView.attributedText = NSMutableAttributedString()
            .normalFont("Hey! Don't forget to meet at ")
            .underlinedFont("\(formatDate(date))")
            .normalFont(".")
    }

    private func setupForNoResponses() {
        statusImageView.image = UIImage(named: "newPear")
        statusLabel.text = "New Pear"
        messageTextView.attributedText = NSMutableAttributedString()
            .normalFont("Uh-oh, looks like neither of you has reached out yet. Be bold and make the first move!")
    }

    private func setupForChatFinished() {
        statusImageView.image = UIImage(named: "finished")
        statusLabel.text = "Finished chat"
        messageTextView.attributedText = NSMutableAttributedString()
            .normalFont("Hope your chat went well! Now you have one more friend at Cornell 😊")
    }

    private func setupForChatCancelled(with user: User) {
        statusImageView.image = UIImage(named: "cancelled")
        statusLabel.text = "Cancelled"

        let fullText = NSMutableAttributedString()
            .normalFont("Oh no, it looks like your schedules don’t line up 😢 I hope it works out next time!")

        if user.instagram != nil || user.facebook != nil {
            fullText
                .normalFont("\nYou can still reach \(user.firstName) on ")
                .socialMediaLinks(instagram: user.instagram, facebook: user.facebook)
                .normalFont(".")
        }
        messageTextView.attributedText = fullText
    }

    /**
    Converts a date to a string formatted:
    [Day of Week], [Month Number]/[Day Number] at [h:mm] [AM/PM] [Time Zone Abbreviation]
    Will Format the date to the current Eastern Time Zone

    # Example:
    The Date for Sunday, September 27 2020 at 9:30 PM Eastern Time would become:
    `"Sunday, 9/27 at 9:30 PM EDT"`
    */
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d 'at' h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = TimeZone(identifier: "America/New_York")!

        let dayOfWeek = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        let monthDayAndTime = dateFormatter.string(from: date)
        let currentTimeZone = dateFormatter.timeZone.abbreviation(for: date) ?? ""

        return "\(dayOfWeek), \(monthDayAndTime) \(currentTimeZone)"
    }

}

// MARK: - NSAttributedString Extension

fileprivate extension NSAttributedString {

    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesFontLeading, .usesLineFragmentOrigin],
                                     context: nil)
        return ceil(rect.size.height)
    }

}

// MARK: - NSMutableAttributedString Extension

extension NSMutableAttributedString {

    func thinFont(_ string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._16CircularStdBook as Any,
            .paragraphStyle: createParagraphStyle(),
            .foregroundColor: UIColor.black
        ]
        self.append(NSMutableAttributedString(string: string, attributes: attributes))
        return self
    }

    func normalFont(_ string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._16CircularStdMedium as Any,
            .paragraphStyle: createParagraphStyle(),
            .foregroundColor: UIColor.black
        ]
        self.append(NSMutableAttributedString(string: string, attributes: attributes))
        return self
    }

    func underlinedFont(_ string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._16CircularStdMedium as Any,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .paragraphStyle: createParagraphStyle(),
            .foregroundColor: UIColor.black
        ]

        self.append(NSMutableAttributedString(string: string, attributes: attributes))
        return self
    }

    func socialMediaLinks(instagram: String? = nil, facebook: String? = nil) -> NSMutableAttributedString {
        let socialMedia = NSMutableAttributedString()

        if let facebook = facebook, let instagram = instagram {
            socialMedia
                .hyperlinkedFont("Instagram", link: instagram)
                .normalFont(" or ")
                .hyperlinkedFont("Facebook", link: facebook)
        } else if let facebook = facebook {
            socialMedia.hyperlinkedFont("Facebook", link: facebook)
        } else if let instagram = instagram {
            socialMedia.hyperlinkedFont("Instagram", link: instagram)
        }

        self.append(socialMedia)
        return self
    }

    private func hyperlinkedFont(_ string: String, link: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._16CircularStdMedium as Any,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .paragraphStyle: createParagraphStyle(),
            .foregroundColor: UIColor.textGreen
        ]
        let link = NSMutableAttributedString(string: string, attributes: attributes)
        link.addAttribute(.link, value: link, range: NSRange(location: 0, length: string.count))
        self.append(link)
        return self
    }

    private func createParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        return paragraphStyle
    }

}
