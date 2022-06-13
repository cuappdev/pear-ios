//
//  EditProfileViewController.swift
//  Pear
//
//  Created by Mathew Scullin on 4/27/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class EditProfileViewController: UIPageViewController {
    
    // MARK: - Private View Vars
    private let backButton = UIButton()
    private var editPages = [UIViewController]()
    private let saveButton = UIButton()
    
    // MARK: - Private Data Vars
    private var currentUser: UserV2

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
            
        view.backgroundColor = .backgroundLightGreen

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.shadowImage = UIImage() // Hide navigation bar bottom shadow
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont._24CircularStdMedium,
            .foregroundColor: UIColor.primaryText
        ]
        navigationItem.title = "Preview"
        
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.darkGreen, for: .normal)
        saveButton.titleLabel?.font = ._20CircularStdMedium
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .inactiveGreen
        pageControl.currentPageIndicatorTintColor = .darkGreen
        
        let editDemographicsViewController = EditDemographicsViewController(user: currentUser)
        let editInterestsViewController = EditProfileSectionsViewController(editProfileSectionType: .interests(currentUser.interests))
        let editGroupsViewController = EditProfileSectionsViewController(editProfileSectionType: .groups(currentUser.groups))
        let editPromptsViewController = EditProfileSectionsViewController(editProfileSectionType: .prompts(currentUser.prompts))
        
        editPages = [
            editDemographicsViewController,
            editInterestsViewController,
            editGroupsViewController,
            editPromptsViewController
        ]
        
        setViewControllers([editPages[0]], direction: .forward, animated: true)
    }
    
    init(currentUser: UserV2) {
        self.currentUser = currentUser
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func savePressed() {
        print("save")
    }

}

extension EditProfileViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = editPages.firstIndex(of: viewController), index > 0 else { return nil }
        
        return editPages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = editPages.firstIndex(of: viewController), index < editPages.count - 1 else { return nil }
        
        return editPages[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        editPages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
    
}
