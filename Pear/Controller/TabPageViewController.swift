//
//  TabPageViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class TabPageViewController: UIPageViewController {

    // MARK: - Private View Vars
    private let communityViewController = CommunityViewController()
    private let matchViewController: UIViewController
    private var pages: [UIViewController] = [UIViewController]()

    private let user: User

    init(match: Match?, user: User) {
        self.user = user

        if let match = match {
            matchViewController = MatchViewController(match: match, user: user)
        } else {
            matchViewController = NoMatchViewController(user: user)
        }
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [matchViewController, communityViewController]
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }

    func setViewController(to index: Int) {
        let direction: UIPageViewController.NavigationDirection = index == 1 ? .forward : .reverse
        self.setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
    }

}
