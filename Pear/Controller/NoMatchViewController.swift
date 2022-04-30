//
//  NoMatchViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Kingfisher
import SideMenu
import UIKit

class NoMatchViewController: UIViewController {

    private let user: UserV2

    // MARK: - Private View Vars
    private let availabilityButton = UIButton()
    private let noMatchLabel = UILabel()
    private let noMatchTitleLabel = UILabel()
    private let pearImageView = UIImageView()
    private let unpauseButton = DynamicButton()
    
    // MARK: - Private Data Vars
    private let isPaused: Bool
    weak var profileDelegate: ProfileMenuDelegate?

    init(user: UserV2, profileDelegate: ProfileMenuDelegate) {
        self.user = user
        self.isPaused = user.isPaused ?? false
        self.profileDelegate = profileDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "" // To get rid of the "back" text on navigation bar
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        let pauseDateString = Time.getPauseDateString(originalString: user.pauseExpiration ?? "")

        pearImageView.image = UIImage(named: isPaused ? "happyPears" : "surprisedPear")
        pearImageView.contentMode = .scaleAspectFit
        view.addSubview(pearImageView)

        noMatchTitleLabel.text = isPaused ? "Your Pear is currently paused." : "Meet your new Pear\nnext Sunday"
        noMatchTitleLabel.numberOfLines = 0
        noMatchTitleLabel.sizeToFit()
        noMatchTitleLabel.textAlignment = .center
        
        let attributedTitle = NSMutableAttributedString()
        
        attributedTitle.append(NSAttributedString(string: isPaused ? "Your Pear is currently " : "Meet your new ", attributes: [.font : UIFont._24CircularStdMedium, .foregroundColor : UIColor.black]))
        attributedTitle.append(NSAttributedString(string: isPaused ? "" : "Pear", attributes: [.font : UIFont._24CircularStdMedium, .foregroundColor : UIColor.darkGreen]))
        attributedTitle.append(NSAttributedString(string: isPaused ? "\npaused." : "\nnext Sunday", attributes: [.font : UIFont._24CircularStdMedium, .foregroundColor : UIColor.black]))
        
        noMatchTitleLabel.attributedText = attributedTitle
        view.addSubview(noMatchTitleLabel)
        
        var noMatchLabelText = ""
        if (isPaused) {
            if (pauseDateString != "") {
                noMatchLabelText = "You will be automatically peared on \(pauseDateString)"
            } else {
                noMatchLabelText = "Jump back when you're ready!"
            }
        } else {
            noMatchLabelText = "In the meantime, browse the people page to see who else is on the app!"
        }
        noMatchLabel.text = noMatchLabelText
        noMatchLabel.numberOfLines = 0
        noMatchLabel.textAlignment = .center
        noMatchLabel.textColor = .greenGray
        noMatchLabel.lineBreakMode = .byWordWrapping
        noMatchLabel.font = ._18CircularStdMedium
        noMatchLabel.sizeToFit()
        view.addSubview(noMatchLabel)
        
        unpauseButton.setTitle("Stop Pausing", for: .normal)
        unpauseButton.setTitleColor(.white, for: .normal)
        unpauseButton.titleLabel?.font = ._18CircularStdBold
        unpauseButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2
        unpauseButton.backgroundColor = .backgroundOrange
        unpauseButton.isEnabled = true
        unpauseButton.isHidden = !isPaused
        unpauseButton.addTarget(self, action: #selector(unpauseButtonPressed), for: .touchUpInside)
        view.addSubview(unpauseButton)
    }

    private func setupConstraints() {
        let subtitleLabelPadding = 15
        let pearImageViewPadding = 18
        let titleLabelPadding = 38
        let imageBottomPadding = isPaused ? 65 : -65
        let noMatchLabelSize = CGSize(width: 293, height: 50)
        let unpauseButtonSize = CGSize(width: 195, height: 48)
        
        noMatchTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(titleLabelPadding)
            make.height.equalTo(65)
        }

        noMatchLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(titleLabelPadding + subtitleLabelPadding)
            make.size.equalTo(noMatchLabelSize)
        }

        pearImageView.snp.makeConstraints { make in
            make.top.equalTo(noMatchTitleLabel.snp.bottom).inset(imageBottomPadding)
            make.bottom.equalTo(unpauseButton.snp.top).offset(imageBottomPadding)
            make.leading.trailing.equalToSuperview().inset(pearImageViewPadding)
        }
        
        unpauseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(noMatchLabel.snp.top).offset(-subtitleLabelPadding)
            make.size.equalTo(unpauseButtonSize)
        }
    }
    
    @objc private func unpauseButtonPressed() {
        NetworkManager.pauseOrUnpausePear(isPausing: false, pauseWeeks: 0) {
            [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.profileDelegate?.didUpdateProfileDemographics()
                } else {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

}
