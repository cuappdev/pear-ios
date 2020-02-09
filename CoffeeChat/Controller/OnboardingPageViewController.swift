//
//  OnboardingViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/6/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

protocol OnboardingPageDelegate {
    func nextPage(index: Int)
    func backPage(index: Int)
}

class OnboardingPageViewController: UIPageViewController {

    var onboardingPages = [UIViewController]()
    let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        let demographicsViewController = DemographicsViewController(delegate: self)
        let interestsViewController = InterestsViewController(delegate: self) // dummy controller
        let groupsViewController = DemographicsViewController(delegate: self) // dummy controller

        onboardingPages = [demographicsViewController, interestsViewController, groupsViewController]

        setViewControllers([onboardingPages[0]], direction: .forward, animated: true, completion: nil)

        pageControl.currentPageIndicatorTintColor = .backgroundDarkGray
        pageControl.pageIndicatorTintColor = .backgroundLightGray
        pageControl.numberOfPages = self.onboardingPages.count
        pageControl.currentPage = 0
        view.addSubview(pageControl)

        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-165)
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
