//
//  NewHomeViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class NewHomeViewController: UIViewController {

    // MARK: - Private View Vars
    private var tabCollectionView: UICollectionView!
    private var tabContainerView: UIView!
    private var tabPageViewController: TabPageViewController!

    // MARK: - Private Data Vars
    private var activeTabIndex = 0
    private let tabCellReuseIdentifier = "tabCellReuseIdentifier"
    private let tabs = ["Discover", "Profile"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray

        tabPageViewController = TabPageViewController()
        addChild(tabPageViewController)

        tabContainerView = UIView()
        view.addSubview(tabContainerView)
        tabPageViewController.view.frame = tabContainerView.frame
        tabContainerView.addSubview(tabPageViewController.view)

        let tabLayout = UICollectionViewFlowLayout()
        tabLayout.minimumInteritemSpacing = 0

        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tabLayout)
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(HomeTabOptionCollectionViewCell.self, forCellWithReuseIdentifier: tabCellReuseIdentifier)
        tabCollectionView.backgroundColor = .white
        tabCollectionView.clipsToBounds = true
        tabCollectionView.layer.masksToBounds = false
        tabCollectionView.layer.cornerRadius = 24
        // Apply corner radius only to bottom left and bottom right corners
        tabCollectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        // TODO: Fix tab bar shadows
        tabCollectionView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        tabCollectionView.layer.shadowOffset = CGSize(width: 4.0, height: 8.0)
        tabCollectionView.layer.shadowOpacity = 0.07
        tabCollectionView.layer.shadowRadius = 4.0
        view.addSubview(tabCollectionView)

        setUpConstraints()
    }

    private func setUpConstraints() {

        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        tabContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
//            make.size.equalTo(CGSize(width: 100, height: 20))
            make.top.equalTo(tabCollectionView.snp.bottom)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

extension NewHomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeTabIndex = indexPath.item
        tabPageViewController.setViewController(to: indexPath.item)
        tabCollectionView.reloadData()
    }

}

extension NewHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabCellReuseIdentifier, for: indexPath) as? HomeTabOptionCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.item == activeTabIndex {
            cell.isSelected = true
        }
        cell.configure(with: tabs[indexPath.item])
        return cell
    }
}

extension NewHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2, height: 60)
    }
}
