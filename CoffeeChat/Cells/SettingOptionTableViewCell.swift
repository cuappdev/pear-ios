//
//  SettingOptionTableViewCell.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/10/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class SettingOptionTableViewCell: UITableViewCell {

    private let optionImageView = UIImageView()
    private let optionLabel = UILabel()
    private let switchView = UISwitch()
    
    weak var delegate: PausePearDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        switchView.onTintColor = .backgroundOrange
        switchView.tintColor = .inactiveGreen
        switchView.backgroundColor = .inactiveGreen
        switchView.layer.cornerRadius = switchView.frame.height / 2.0
        switchView.clipsToBounds = true
        switchView.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        
        optionLabel.textColor = .black
        optionLabel.font = ._16CircularStdBook
        contentView.addSubview(optionLabel)
        
        optionImageView.clipsToBounds = true
        optionImageView.contentMode = .scaleAspectFit
        contentView.addSubview(optionImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        optionImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(32)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.leading.equalTo(optionImageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func configure(for option: SettingOption) {
        optionImageView.image = UIImage(named: option.image)
        optionLabel.text = option.text
        if option.hasSwitch {
            accessoryView = switchView
            switchView.setOn(option.switchOn, animated: false)
        }
    }
    
    @objc func switchToggled() {
        if switchView.isOn {
            delegate?.presentPausePear()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
