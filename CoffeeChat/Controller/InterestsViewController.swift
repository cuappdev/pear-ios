//
//  InterestsViewController.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/3/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class InterestsViewController: UIViewController {

    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let nextButton = UIButton()
    private let backButton = UIButton()
    private let dotsView = UIView()

    private let nextSize = CGSize(width: 112.5, height: 27)

    private let interestData = [
        Interest(name: "Aaaa", categories: "..., ..., ..., ..., ...", image: UIImage()),
        Interest(name: "Bbbbbb", categories: "..., ..., ..., ..., ...", image: UIImage()),
        Interest(name: "Cccc", categories: "..., ..., ..., ..., ...", image: UIImage()),
        Interest(name: "Ddddddddd", categories: "..., ..., ..., ..., ...", image: UIImage()),
        Interest(name: "Eeeeeeee", categories: "..., ..., ..., ..., ...", image: UIImage()),
        Interest(name: "Ffff", categories: "..., ..., ..., ..., ...", image: UIImage())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundWhite

        titleLabel.text = "What are your interests?"
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        view.addSubview(titleLabel)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InterestsTableViewCell.self, forCellReuseIdentifier: InterestsTableViewCell.reuseIdentifier)
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        dotsView.backgroundColor = .backgroundLightGray
        view.addSubview(dotsView)

        nextButton.setTitle("Almost there!", for: .normal)
        nextButton.layer.cornerRadius = nextSize.height * 0.8 // ? guess
        nextButton.backgroundColor = .backgroundLightGray
        nextButton.setTitleColor(.textBlack, for: .normal)
        view.addSubview(nextButton)

        backButton.setTitle("Go back", for: .normal)
        backButton.setTitleColor(.textLightGray, for: .normal)
        backButton.backgroundColor = .none
        view.addSubview(backButton)

        setUpConstraints()
    }

    private func setUpConstraints() {
        let titleHeight: CGFloat = 30
        let tableViewSize = CGSize(width: 147.5, height: 215.5) // height is a guess
        let dotsSize = CGSize(width: 14, height: 3) // likely to change
        let backSize = CGSize(width: 34.5, height: 11.5)
        let padding: CGFloat = 10
        let tableDotsPadding: CGFloat = 14
        let nextBackPadding: CGFloat = 11

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
        }

        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(tableViewSize)
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
        }

        dotsView.snp.makeConstraints { make in // Likely changing
            make.size.equalTo(dotsSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom).offset(tableDotsPadding)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(dotsView).offset(padding)
        }

        backButton.snp.makeConstraints { make in
            make.size.equalTo(backSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(nextButton).offset(nextBackPadding)
        }
    }

}

extension InterestsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34.5
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}


extension InterestsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interestData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cellForRowAt(at: indexPath) as? InterestsTableViewCell else { return UITableViewCell() }
        let data = interestData[indexPath.section]
        cell.configure(with: data)
        return cell
    }

}
