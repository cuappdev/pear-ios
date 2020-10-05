//  MeetupStatusView.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 9/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

enum ChatStatus {
    case finished, cancelled, noResponses
}

class MeetupStatusView: UIView {

    private let backgroundShadingView = UIView()
    private let messageLabel = UILabel()
    private let pearImageView = UIImageView()
    private let statusImageView = UIImageView()
    private let statusLabel = UILabel()

    private let pearImageSize = CGSize(width: 40, height: 40)

    let unformattedStyle: [NSAttributedString.Key: Any]
    let underlinedStyle: [NSAttributedString.Key: Any]
    let hyperlinkedStyle: [NSAttributedString.Key: Any]

    convenience init(respondingTo name: String) {
        self.init()

        setupForResponding(to: name)
    }

    convenience init(waitingOn name: String) {
        self.init()

        setupForWaiting(for: name)
    }

    convenience init(forChatScheduledOn date: Date, name: String, instagram: String? = nil, facebook: String? = nil) {
        self.init()

        if isTommorow(meeting: date) {
            //setupForDayBeforeMeeting(on: date)
            setupForChatScheduled(on: date, name: name, instagram: instagram, facebook: facebook)
        } else {
            setupForChatScheduled(on: date, name: name, instagram: instagram, facebook: facebook)
        }
    }

    convenience init(for status: ChatStatus) {
        self.init()

        switch status {
        case .cancelled:
            setupForChatCancelled()
        case .noResponses:
            setupForNoResponses()
        case .finished:
            setupForChatFinished()
        }
    }

    init() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        unformattedStyle = [
            .font: UIFont._16CircularStdMedium as Any,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.textBlack
        ]
        underlinedStyle = [
            .font: UIFont._16CircularStdMedium as Any,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.textBlack
        ]
        hyperlinkedStyle = [
            .font: UIFont._16CircularStdMedium as Any,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.textGreen
        ]

        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundShadingView.backgroundColor = .backgroundLightGrayGreen
        backgroundShadingView.layer.cornerRadius = 12
        addSubview(backgroundShadingView)

        statusLabel.textColor = .textGreen
        statusLabel.font = ._12CircularStdMedium
        statusLabel.numberOfLines = 0
        addSubview(statusLabel)

        statusImageView.image = UIImage(named: "happyPear")
        addSubview(statusImageView)

        messageLabel.font = UIFont._16CircularStdMedium
        messageLabel.textColor = .textBlack
        messageLabel.numberOfLines = 0
        backgroundShadingView.addSubview(messageLabel)

        pearImageView.image = UIImage(named: "happyPear")
        pearImageView.layer.cornerRadius = pearImageSize.width / 2
        pearImageView.layer.shadowColor = UIColor.black.cgColor
        pearImageView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        pearImageView.layer.shadowOpacity = 0.15
        pearImageView.layer.shadowRadius = 2
        backgroundShadingView.addSubview(pearImageView)
    }

    private func setupConstraints() {
        let statusImageSize = CGSize(width: 10, height: 10)
        let statusMessagePadding = 4
        let pearSidePadding = 8
        let messageLeadingPadding = 12
        let messageTrailingPadding = 8

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
            make.leading.equalTo(backgroundShadingView).inset(pearSidePadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(pearImageSize)
        }

        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(pearImageView.snp.trailing).offset(messageLeadingPadding)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(messageTrailingPadding)
        }
    }

    // MARK: Different View States

    private func setupForResponding(to name: String) {
        statusImageView.image = UIImage(named: "new-pear")
        statusLabel.text = "New Pear"
        messageLabel.text = "\(name) wants to meet you! Pick a time that works for both of you."
    }

    private func setupForWaiting(for name: String) {
        statusImageView.image = UIImage(named: "reached-out")
        statusLabel.text = "Reached out"
        messageLabel.text = "Just waiting on \(name) to pick a time and place!"
    }

    private func setupForChatScheduled(on date: Date, name: String, instagram: String? = nil, facebook: String? = nil) {
        statusImageView.image = UIImage(named: "scheduled")
        statusLabel.text = "Chat scheduled"

        let prefix = unformattedText(for: "Get pumped to meet on ")
        let body = underlinedText(for: "\(formatDate(date))")
        let suffix = unformattedText(for: ".")

        let fullText = NSMutableAttributedString()
        fullText.append(prefix)
        fullText.append(body)
        fullText.append(suffix)

        if instagram != nil || facebook != nil {
            let contactPrefix = unformattedText(for: "\nYou can reach \(name) on ")
            let contactLinks = textForSocialMedia(facebook: facebook, instagram: instagram)
            let contactSuffix = unformattedText(for: ".")
            fullText.append(contactPrefix)
            fullText.append(contactLinks)
            fullText.append(contactSuffix)
        }

        messageLabel.attributedText = fullText
    }

    private func setupForDayBeforeMeeting(on date: Date) {
        statusImageView.image = UIImage(named: "scheduled")
        statusLabel.text = "Chatting soon"

        let prefix = unformattedText(for: "Hey! Don't forget to meet at ")
        let body = underlinedText(for: "\(formatDate(date))")
        let suffix = unformattedText(for: ".")

        let fullText = NSMutableAttributedString()
        fullText.append(prefix)
        fullText.append(body)
        fullText.append(suffix)

        messageLabel.attributedText = fullText
    }

    private func setupForNoResponses() {
        statusLabel.text = "New Pear"
        messageLabel.text = "Uh-oh, looks like neither of you has reached out yet. Be bold and make the first move!"
    }

    private func setupForChatFinished() {
        // TODO
    }

    private func setupForChatCancelled() {
        // TODO
    }

    // MARK: Attributed Strings
    private func textForSocialMedia(facebook: String? = nil, instagram: String? = nil) -> NSMutableAttributedString {
        if let facebook = facebook, let instagram = instagram {
            let socialMedia = NSMutableAttributedString()
            socialMedia.append(hyperlinkedText(for: "Instagram", to: instagram))
            socialMedia.append(unformattedText(for: " or "))
            socialMedia.append(hyperlinkedText(for: "Facebook", to: facebook))
            return socialMedia
        } else if let facebook = facebook {
            return hyperlinkedText(for: "Facebook", to: facebook)
        } else if let instagram = instagram {
            return hyperlinkedText(for: "Instagram", to: instagram)
        } else {
            return unformattedText(for: "")
        }
    }

    private func unformattedText(for string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: unformattedStyle)
    }

    private func underlinedText(for string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: underlinedStyle)
    }

    private func hyperlinkedText(for string: String, to link: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: hyperlinkedStyle)
        attributedString.addAttribute(.link, value: link, range: NSRange(location: 0, length: string.count))
        return attributedString
    }

    // MARK: Date Manipulation

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
        dateFormatter.dateFormat = "M/d 'at' h:m a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = TimeZone(identifier: "America/New_York")!

        let dayOfWeek = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        let monthDayAndTime = dateFormatter.string(from: date)
        let currentTimeZone = dateFormatter.timeZone.abbreviation(for: date) ?? ""

        return "\(dayOfWeek), \(monthDayAndTime) \(currentTimeZone)"
    }

    /**
    Returns true if meeting is tommorow or today. "Tommorow" is defined as one calendar day after today rather than 24 hours ahead.

    # Example:
    If today is October 4th 12:00 PM and the meeting is October 5th 12:00 PM this returns true
    If today is October 4th 12:00 PM and the meeting is October 6th 12:00 PM this returns false
    If today is October 4th 1:00 AM and the meeting is October 5th 11:00 PM this returns true
    */
    private func isTommorow(meeting: Date) -> Bool {
        if
        let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()),
        let meetingDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: meeting)
        {
            if let dayDifference = Calendar.current.dateComponents([.day], from: today, to: meetingDate).day {
                return dayDifference <= 1
            }
        }

        return false
    }

}
