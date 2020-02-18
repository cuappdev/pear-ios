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

    // MARK: - Private View Vars
    private var demographicsViewController: DemographicsViewController!
    private var groupsViewController: GroupsViewController!
    private var interestsViewController: OnboardingInterestsViewController!
    private var onboardingPages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        demographicsViewController = DemographicsViewController(delegate: self)
        interestsViewController = OnboardingInterestsViewController(delegate: self)
        groupsViewController = GroupsViewController(delegate: self)
        onboardingPages = [demographicsViewController, interestsViewController, groupsViewController]

        setViewControllers([onboardingPages[0]], direction: .forward, animated: true, completion: nil)
    }
}

extension OnboardingPageViewController: OnboardingPageDelegate {
    func nextPage(index: Int) {
        setViewControllers([onboardingPages[index]], direction: .forward, animated: true, completion: nil)
    }

    func backPage(index: Int) {
        setViewControllers([onboardingPages[index]], direction: .reverse, animated: true, completion: nil)
    }
}
