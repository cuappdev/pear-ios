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
    private let surprisedPearImageView = UIImageView()

    init(user: UserV2) {
        self.user = user
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

        surprisedPearImageView.image = UIImage(named: "surprisedPear")
        surprisedPearImageView.contentMode = .scaleAspectFit
        view.addSubview(surprisedPearImageView)

        noMatchTitleLabel.text = "Meet your new Pear\nnext Monday"
        noMatchTitleLabel.numberOfLines = 0
        noMatchTitleLabel.sizeToFit()
        noMatchTitleLabel.textAlignment = .center
        noMatchTitleLabel.textColor = .black
        noMatchTitleLabel.font = ._24CircularStdMedium
        view.addSubview(noMatchTitleLabel)

        noMatchLabel.text = "In the meantime, browse the people page to see who else is on the app!"
        noMatchLabel.numberOfLines = 0
        noMatchLabel.textAlignment = .center
        noMatchLabel.textColor = .greenGray
        noMatchLabel.lineBreakMode = .byWordWrapping
        noMatchLabel.font = ._16CircularStdMedium
        noMatchLabel.sizeToFit()
        view.addSubview(noMatchLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        let buttonBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 48)
        let imageBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 36)
        let imageWidth = (UIScreen.main.bounds.width / 375) * 176
        let subtitleLabelPadding: CGFloat = Constants.Onboarding.skipBottomPadding
        let titleLabelPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 76)

        noMatchTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(titleLabelPadding)
            make.height.equalTo(65)
        }

        noMatchLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(293)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(buttonBottomPadding + subtitleLabelPadding)
            make.height.equalTo(50)
        }

        surprisedPearImageView.snp.makeConstraints { make in
            make.top.equalTo(noMatchTitleLabel.snp.bottom).offset(imageBottomPadding)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(noMatchLabel.snp.top).offset(-imageBottomPadding)
            make.width.equalTo(imageWidth)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

}
