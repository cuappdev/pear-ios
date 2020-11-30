//
//  NoMatchViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class NoMatchViewController: UIViewController {

    // MARK: - Private View Vars
    private let availabilityButton = UIButton()
    private let noMatchLabel = UILabel()
    private let noMatchTitleLabel = UILabel()
    private let surprisedPearImageView = UIImageView()
    private var savedAvailabilities: [String: [String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "" // To get rid of the "back" text on navigation bar
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true

        let buttonSize = CGSize(width: 225, height: 54)
        let buttonBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 102)
        let imageBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 36)
        let imageWidth = (UIScreen.main.bounds.width / 375) * 176
        let subtitleLabelPadding: CGFloat = Constants.Onboarding.skipBottomPadding
        let titleLabelPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 92)

        surprisedPearImageView.image = UIImage(named: "surprisedPear")
        surprisedPearImageView.contentMode = .scaleAspectFit
        view.addSubview(surprisedPearImageView)

        noMatchTitleLabel.text = "Meet your new Pear\nnext Sunday"
        noMatchTitleLabel.numberOfLines = 2
        noMatchTitleLabel.sizeToFit()
        noMatchTitleLabel.textAlignment = .center
        noMatchTitleLabel.textColor = .black
        noMatchTitleLabel.font = ._24CircularStdMedium
        view.addSubview(noMatchTitleLabel)

        noMatchLabel.text = "In the meantime, tell me when you're\nusually free to make meeting up easier!"
        noMatchLabel.numberOfLines = 2
        noMatchLabel.textAlignment = .center
        noMatchLabel.textColor = .greenGray
        noMatchLabel.sizeToFit()
        noMatchLabel.font = ._16CircularStdMedium
        view.addSubview(noMatchLabel)

        availabilityButton.setTitle("Enter availability", for: .normal)
        availabilityButton.setTitleColor(.white, for: .normal)
        availabilityButton.titleLabel?.font = ._20CircularStdBold
        availabilityButton.backgroundColor = .backgroundOrange
        availabilityButton.layer.cornerRadius = 26
        availabilityButton.addTarget(self, action: #selector(availabilityButtonPressed), for: .touchUpInside)
        view.addSubview(availabilityButton)

        noMatchTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleLabelPadding)
        }

        noMatchLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(availabilityButton.snp.top).offset(-subtitleLabelPadding)
        }

        surprisedPearImageView.snp.makeConstraints { make in
            make.top.equalTo(noMatchTitleLabel.snp.bottom).offset(imageBottomPadding)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(noMatchLabel.snp.top).offset(-imageBottomPadding)
            make.width.equalTo(imageWidth)
        }

        availabilityButton.snp.makeConstraints { make in
           make.size.equalTo(buttonSize)
           make.centerX.equalToSuperview()
           make.bottom.equalTo(view.safeAreaLayoutGuide).inset(buttonBottomPadding)
        }
     }

    private func floatToStringTime(time: Float) -> String {
        let hoursMins = Time.floatTimeToHoursMinutes(time: time)
        var hoursInt = hoursMins.0
        if hoursInt > 12 {
            hoursInt -= 12
        }
        let hours = String(hoursInt)
        let mins = String(hoursMins.1)
        return "\(hours):\(mins)"
    }

    private func getTimeAvailabilities(netID: String, user: Bool) {
        NetworkManager.shared.getTimeAvailabilities(netID: netID).observe { response in
            switch response {
            case .value(let value):
                guard value.success else { return }
                var availabilities: [String: [String]] = [:]
                for data in value.data.availabilities {
                    availabilities[data.day.localizedCapitalized] = data.times.map({self.floatToStringTime(time: $0)})
                }
                self.savedAvailabilities = availabilities
            case .error(let error):
                print(error)
            }
        }
    }

    @objc private func availabilityButtonPressed() {
        let timeVC = SchedulingTimeViewController(for: .pickingTypical, savedAvailabilities: savedAvailabilities, matchAvailabilities: [:])
        navigationController?.pushViewController(timeVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

}
