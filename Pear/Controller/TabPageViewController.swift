//
//  TabPageViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

protocol TabDelegate: AnyObject {
    func setActiveTabIndex(to index: Int)
}

class TabPageViewController: UIPageViewController {

    // MARK: - Private View Vars
    private let communityViewController : UIViewController
    private let matchViewController: UIViewController
    private var pages: [UIViewController] = [UIViewController]()

    // MARK: - Data Vars
    private let user: UserV2
    weak var tabDelegate: TabDelegate?

    init(user: UserV2, tabDelegate: TabDelegate) {
        self.user = user
        self.tabDelegate = tabDelegate

        if let _ = user.currentMatch {
            matchViewController = MatchProfileViewController(user: user)
        } else {
            matchViewController = NoMatchViewController(user: user)
        }
        
        communityViewController = CommunityViewController(user: user)
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeDetected))
        leftSwipeGestureRecognizer.direction = .left

        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeDetected))
        rightSwipeGestureRecognizer.direction = .right

        view.addGestureRecognizer(leftSwipeGestureRecognizer)
        view.addGestureRecognizer(rightSwipeGestureRecognizer)

        pages = [matchViewController, communityViewController]
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }

    func setViewController(to index: Int) {
        let direction: UIPageViewController.NavigationDirection = index == 1 ? .forward : .reverse
        self.setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
    }

    @objc func leftSwipeDetected() {
        tabDelegate?.setActiveTabIndex(to: 1)
    }

    @objc func rightSwipeDetected() {
        tabDelegate?.setActiveTabIndex(to: 0)
    }

}
