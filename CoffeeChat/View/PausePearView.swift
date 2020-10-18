//
//  PausePearView.swift
//  CoffeeChat
//
//  Created by Amy Chin Siu Huang on 10/15/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class PausePearView: UIView {

    // MARK: - Private View Vars
    private let pauseLabel = UILabel()
    private let oneWeekButton = UIButton()
    private let twoWeekButton = UIButton()
    private let threeWeekButton = UIButton()
    private let cancelButton = UIButton()
    
    // MARK: - Private Data Vars
    private weak var delegate: PausePearDelegate?
    
    init(delegate: PausePearDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setUpViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.backgroundColor = .backgroundLightGreen
        self.layer.cornerRadius = 36
        
        pauseLabel.text = "Pause Pear for..."
        pauseLabel.font = ._20CircularStdBook
        pauseLabel.textAlignment = .center
        pauseLabel.textColor = .black
        addSubview(pauseLabel)
        
        oneWeekButton.setTitle("1 Week", for: .normal)
        oneWeekButton.layer.cornerRadius = 8
        oneWeekButton.backgroundColor = .white
        oneWeekButton.setTitleColor(.black, for: .normal)
        oneWeekButton.titleLabel?.font = ._16CircularStdBook
        oneWeekButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        addSubview(oneWeekButton)
        
        twoWeekButton.setTitle("2 Weeks", for: .normal)
        twoWeekButton.layer.cornerRadius = 8
        twoWeekButton.backgroundColor = .white
        twoWeekButton.setTitleColor(.black, for: .normal)
        twoWeekButton.titleLabel?.font = ._16CircularStdBook
        twoWeekButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        addSubview(twoWeekButton)
        
        threeWeekButton.setTitle("3 Weeks", for: .normal)
        threeWeekButton.layer.cornerRadius = 8
        threeWeekButton.backgroundColor = .white
        threeWeekButton.setTitleColor(.black, for: .normal)
        threeWeekButton.titleLabel?.font = ._16CircularStdBook
        threeWeekButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        addSubview(threeWeekButton)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.textGreen, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = ._16CircularStdBook
        cancelButton.addTarget(self, action: #selector(cancelPause), for: .touchUpInside)
        addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        let weekButtonSize = CGSize(width: 110, height: 40)
        let cancelButtonSize = CGSize(width: 52, height: 20)
        
        pauseLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(36)
            make.leading.trailing.equalToSuperview().inset(75)
        }
        
        oneWeekButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(pauseLabel.snp.bottom).offset(22)
            make.size.equalTo(weekButtonSize)
        }
        
        twoWeekButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneWeekButton.snp.bottom).offset(12)
            make.size.equalTo(weekButtonSize)
        }
        
        threeWeekButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(twoWeekButton.snp.bottom).offset(12)
            make.size.equalTo(weekButtonSize)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(threeWeekButton.snp.bottom).offset(30)
            make.size.equalTo(cancelButtonSize)
        }
    }
    
    @objc private func buttonAction(button: UIButton) {
        if let pauseTime = button.titleLabel?.text {
            delegate?.pausePearAction(data: pauseTime)
            oneWeekButton.backgroundColor = .white
            twoWeekButton.backgroundColor = .white
            threeWeekButton.backgroundColor = .white
            button.backgroundColor = .pearGreen
        }
    }
    
    @objc private func cancelPause() {
        delegate?.removePausePear()
    }
    
}
