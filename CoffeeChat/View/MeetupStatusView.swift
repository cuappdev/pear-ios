//
//  MeetupStatusView.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 9/26/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class MeetupStatusView: UIView {

    private let backgroundShadingView = UIView()
    private let messageLabel = UILabel()
    private let pearImageView = UIImageView()
    private let statusImageView = UIImageView()
    private let statusLabel = UILabel()

    private let pearImageSize = CGSize(width: 40, height: 40)

    convenience init(forNewPair name: String) {
        self.init()
        setupForNewPair(with: name)
    }

    convenience init (reachingOutTo name: String) {
        self.init()
        setupForReachingOut(with: name)
    }

    convenience init(chatScheduledOn date: Date) {
        self.init()
        setupForChatScheduled(on: date)
    }

    private init() {
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

    private func setupForNewPair(with name: String) {
        statusLabel.text = "New Pear"
        messageLabel.text = "\(name) wants to meet you! Pick a time that works for both of you."
    }

    private func setupForReachingOut(with name: String) {
        statusLabel.text = "Reached out"
        messageLabel.text = "Just waiting on \(name) to pick a time and place!"
    }

    private func setupForChatScheduled(on date: Date) {
        statusLabel.text = "Chat scheduled"

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        let unformattedText: [NSAttributedString.Key: Any] = [
            .font: UIFont._16CircularStdMedium as Any,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.textBlack
        ]
        let underlinedText: [NSAttributedString.Key: Any] = [
            .font: UIFont._16CircularStdMedium as Any,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.textBlack
        ]

        let prefix = NSMutableAttributedString(string: "Get pumped to meet on ", attributes: unformattedText)
        let body = NSMutableAttributedString(string: "\(formatDate(date))", attributes: underlinedText)
        let suffix = NSMutableAttributedString(string: ".", attributes: unformattedText)

        let fullText = NSMutableAttributedString()
        fullText.append(prefix)
        fullText.append(body)
        fullText.append(suffix)

        messageLabel.attributedText = fullText
    }

    /**
     Converts a date to a string formatted:
     [Day of Week], [Month Number]/[Day Number] at [h:mm] [AM/PM] [Time Zone Abbreviation]
     Will Format the date to the current Eastern Time Zone

    Example:
    The Date for Sunday, September 27 2020 at 9:30 PM Eastern Time would become:
    "Sunday, 9/27 at 9:30 PM EDT"
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

}
