//
//  OnboardingPageViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/6/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

protocol OnboardingPageDelegate: class {
    func nextPage(index: Int)
    func backPage(index: Int)
}

class OnboardingPageViewController: UIPageViewController {

    private var demographicsViewController: DemographicsViewController!
    private var groupsViewController: GroupsViewController!
    private var interestsViewController: InterestsViewController!
    private var onboardingPages = [UIViewController]()

    private let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        demographicsViewController = DemographicsViewController(delegate: self)
        interestsViewController = InterestsViewController(delegate: self)
        groupsViewController = GroupsViewController(delegate: self)
        onboardingPages = [demographicsViewController, interestsViewController, groupsViewController]

        setViewControllers([onboardingPages[0]], direction: .forward, animated: true, completion: nil)

        pageControl.currentPageIndicatorTintColor = .backgroundDarkGray
        pageControl.pageIndicatorTintColor = .backgroundLightGray
        pageControl.numberOfPages = onboardingPages.count
        pageControl.currentPage = 0
        view.addSubview(pageControl)

        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(165)
        }
    }
}

extension OnboardingPageViewController: OnboardingPageDelegate {
    func nextPage(index: Int) {
        setViewControllers([onboardingPages[index]], direction: .forward, animated: true, completion: nil)
        self.pageControl.currentPage = index;
    }

    func backPage(index: Int) {
        setViewControllers([onboardingPages[index]], direction: .reverse, animated: true, completion: nil)
        self.pageControl.currentPage = index;
    }
}
