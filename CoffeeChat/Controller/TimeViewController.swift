//
//  TimeViewController.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/19/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
    
    let titleLabel = UILabel()
//    let dayCollectionView = UICollectionView()
    let dayLabel = UILabel()
//    let timeCollectionView = UICollectionView()
    let finishButton = UIButton()
    
    let availabilities = {}
    
    let morningTimes = ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30"]
    let afternoonTimes = ["1:00", "1:30", "2:00", "2:30", "3:00", "3:30", "4:00", "4:30",]
    let eveningTimes = ["5:00", "5:30", "6:00", "6:30", "7:00", "7:30", "8:00", "8:30"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let day = "Monday"
        
        titleLabel.text = "When are you free?"
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)
        
//        dayLabel.text  = "Every \(day)"
//        view.addSubview(dayLabel)
//
//        finishButton.setTitle("Finish", for: .normal)
//        view.addSubview(finishButton)
//
//        view.addSubview(dayCollectionView)
//        view.addSubview(timeCollectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }
        
    }

}
