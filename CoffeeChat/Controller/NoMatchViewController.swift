//
//  NoMatchViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Kingfisher
import UIKit
import SideMenu

class NoMatchViewController: UIViewController {

    // MARK: - Private View Vars
    private let availabilityButton = UIButton()
    private let noMatchLabel = UILabel()
    private let noMatchTitleLabel = UILabel()
    private let profileButton = UIButton(type: .custom)
    private let surprisedPearImageView = UIImageView()
    
    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "" // To get rid of the "back" text on navigation bar
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true
        
        profileButton.backgroundColor = .inactiveGreen
        profileButton.layer.cornerRadius = 17.5
        profileButton.layer.shadowColor = UIColor.black.cgColor
        profileButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        profileButton.layer.shadowOpacity = 0.15
        profileButton.layer.shadowRadius = 2
        profileButton.layer.masksToBounds = true
        profileButton.clipsToBounds = true
        profileButton.addTarget(self, action: #selector(profilePressed), for: .touchUpInside)
        view.addSubview(profileButton)

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
        
        getUserMatching()
        setupConstraints()
    }
    
    private func setupConstraints() {
        let buttonSize = CGSize(width: 225, height: 54)
        let buttonBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 102)
        let imageBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 36)
        let imageWidth = (UIScreen.main.bounds.width / 375) * 176
        let subtitleLabelPadding: CGFloat = Constants.Onboarding.skipBottomPadding
        let titleLabelPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 92)
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }

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

    private func getUserMatching() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getUser(netId: netId).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        let user = response.data
                        if let profilePictureURL = URL(string: user.profilePictureURL) {
                            self.profileButton.kf.setImage(with: profilePictureURL, for: .normal)
                        }
                        self.user = user
                        
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc private func availabilityButtonPressed() {
        let timeVC = SchedulingTimeViewController(for: .pickingTypical)
        navigationController?.pushViewController(timeVC, animated: true)
    }
    
    @objc private func profilePressed() {
        guard let user = user else { return }
        let menu = SideMenuNavigationController(rootViewController: ProfileMenuViewController(user: user))
        let presentationStyle: SideMenuPresentationStyle = .viewSlideOutMenuPartialIn
        presentationStyle.presentingEndAlpha = 0.85
        menu.presentationStyle = presentationStyle
        menu.leftSide = true
        menu.statusBarEndAlpha = 0
        menu.menuWidth = view.frame.width * 0.8
        present(menu, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

}
