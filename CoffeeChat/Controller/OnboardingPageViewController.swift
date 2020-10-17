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
    private let backgroundImage = UIImageView()
    private var demographicsViewController: DemographicsViewController!
    private var goalsViewController: GoalsViewController!
    private var groupsViewController: GroupsViewController!
    private var interestsViewController: InterestsViewController!
    private var interestsGroupsViewController: InterestsGroupsViewController!
    private var onboardingPages = [UIViewController]()
    private var socialMediaViewController: SocialMediaViewController!

    // MARK: - Private Data Vars
    private var backgroundXPosition: CGFloat = UIScreen.main.bounds.width
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private var scrollContentOffset = UIScreen.main.bounds.width

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }

        backgroundImage.image = UIImage(named: "onboardingBackground")
        backgroundImage.contentMode =  .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        backgroundImage.frame = CGRect(x: backgroundXPosition, y: 0, width: screenWidth, height: screenHeight)

        demographicsViewController = DemographicsViewController(delegate: self)
        interestsViewController = InterestsViewController(delegate: self)
        interestsGroupsViewController = InterestsGroupsViewController(delegate: self)
        groupsViewController = GroupsViewController(delegate: self)
        goalsViewController = GoalsViewController(delegate: self)
        socialMediaViewController = SocialMediaViewController(delegate: self)
        onboardingPages = [
            demographicsViewController,
            interestsViewController,
            groupsViewController,
            goalsViewController,
            interestsGroupsViewController,
            socialMediaViewController
        ]

        setViewControllers([onboardingPages[0]], direction: .forward, animated: true, completion: nil)
    }
}

extension OnboardingPageViewController: OnboardingPageDelegate, UIScrollViewDelegate {
    func nextPage(index: Int) {
        setViewControllers([onboardingPages[index]], direction: .forward, animated: true, completion: nil)
    }

    func backPage(index: Int) {
        setViewControllers([onboardingPages[index]], direction: .reverse, animated: true, completion: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Update x position based on screen size when page scrolls
        let scrollRate: CGFloat = scrollView.contentOffset.x - scrollContentOffset > 0 ? -0.04 : 0.04
        backgroundXPosition += scrollRate * screenWidth
        scrollContentOffset = scrollView.contentOffset.x
        backgroundImage.frame.origin = CGPoint(x: backgroundXPosition, y: 0)
    }
}
