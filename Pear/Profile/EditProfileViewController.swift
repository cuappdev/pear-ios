//
//  EditProfileViewController.swift
//  Pear
//
//  Created by Mathew Scullin on 4/27/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

protocol didEditProfileDelegate: AnyObject {
    func updateUser(updatedUser: UserV2)
}

class EditProfileViewController: UIPageViewController {
    
    // MARK: - Private View Vars
    private let backButton = UIButton()
    private var editPages = [UIViewController]()
    private let saveButton = UIButton()
    
    // MARK: - Private Data Vars
    private var currentUser: UserV2
    var profileDelegate: didUpdateProfileViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
///        Only make the network request to get the user for the first time that this page loads -> or else
///        when view appears, we want to be passing the user in rather than getting it again from the backend
        NetworkManager.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.currentUser = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dataSource = self
            
        view.backgroundColor = .backgroundLightGreen

//        navigationController?.navigationBar.isHidden = false
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
        
        let editDemographicsViewController = EditDemographicsViewController(user: currentUser, delegate: self)
        let editInterestsViewController = EditProfileSectionsViewController(editProfileSectionType: .interests(currentUser.interests), delegate: self, currentUser: currentUser)
        let editGroupsViewController = EditProfileSectionsViewController(editProfileSectionType: .groups(currentUser.groups), delegate: self, currentUser: currentUser)
        let editPromptsViewController = EditProfileSectionsViewController(editProfileSectionType: .prompts(currentUser.prompts), delegate: self, currentUser: currentUser)
        
        editPages = [
            editDemographicsViewController,
            editInterestsViewController,
            editGroupsViewController,
            editPromptsViewController
        ]
        
        setViewControllers([editPages[0]], direction: .forward, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    init(currentUser: UserV2, delegate: didUpdateProfileViewDelegate) {
        self.profileDelegate = delegate
        self.currentUser = currentUser
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// Passing back to the ProfileViewController to update the information displayed there
    @objc private func backPressed() {
        profileDelegate?.updateProfileUser(updatedUser: currentUser)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func savePressed() {
        profileDelegate?.updateProfileUser(updatedUser: currentUser)
        navigationController?.popViewController(animated: true)
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

/// Passes the user back to the ProfileViewController so that it can be updated there
extension EditProfileViewController: didEditProfileDelegate {
    func updateUser(updatedUser: UserV2) {
        currentUser = updatedUser
    }
}

extension EditProfileViewController: didEditDemographicsDelegate {
    func updateDemographics(updatedUser: UserV2) {
        currentUser = updatedUser
    }
}
