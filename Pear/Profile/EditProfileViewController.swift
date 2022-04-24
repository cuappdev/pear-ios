//
//  EditProfileViewController.swift
//  Pear
//
//  Created by Mathew Scullin on 4/17/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let dotView = DotView()
    private var editOptions = [UIView]()
    private var profileSectionsCollectionView: FadeWrapperView<UICollectionView>!
    private var saveButton = UIButton()
    
    // MARK: - Private Data Vars
    private var currentUser: UserV2
    private var profileSections = [ProfileSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        view.addSubview(dotView)
        
        let profileEditCollectionViewLayout = UICollectionViewFlowLayout()
        profileEditCollectionViewLayout.scrollDirection = .horizontal
        profileEditCollectionViewLayout.minimumInteritemSpacing = 0
        profileEditCollectionViewLayout.minimumLineSpacing = 0

        profileSectionsCollectionView = FadeWrapperView(UICollectionView(frame: .zero, collectionViewLayout: profileEditCollectionViewLayout), fadeColor: .backgroundLightGreen)
        profileSectionsCollectionView.view.register(EditDemographicsCollectionViewCell.self, forCellWithReuseIdentifier: EditDemographicsCollectionViewCell.reuseIdentifier)
        profileSectionsCollectionView.view.register(EditInterestsGroupsPromptsCollectionViewCell.self, forCellWithReuseIdentifier: EditInterestsGroupsPromptsCollectionViewCell.reuseIdentifier)
        profileSectionsCollectionView.view.dataSource = self
        profileSectionsCollectionView.view.delegate = self
        profileSectionsCollectionView.view.showsHorizontalScrollIndicator = false
        profileSectionsCollectionView.view.isPagingEnabled = true
        view.addSubview(profileSectionsCollectionView)
        
        profileSections = [.basics, .interests, .groups, .prompts]
        
        setupConstraints()
    }
    
    init(currentUser: UserV2) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        dotView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(54)
            make.height.equalTo(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        profileSectionsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(dotView.snp.top)
        }
    }
    
    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func savePressed() {
        print("save")
    }
}

extension EditProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profileSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = profileSections[indexPath.row]
        switch section {
        case .basics:
            guard let cell = profileSectionsCollectionView.view.dequeueReusableCell(withReuseIdentifier: EditDemographicsCollectionViewCell.reuseIdentifier, for: indexPath) as? EditDemographicsCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(user: currentUser)
            return cell
        default:
            guard let cell = profileSectionsCollectionView.view.dequeueReusableCell(withReuseIdentifier: EditInterestsGroupsPromptsCollectionViewCell.reuseIdentifier, for: indexPath) as? EditInterestsGroupsPromptsCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(editType: section, currentUser: currentUser)
            return cell
        }
    }
    
}

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout
     collectionViewLayout: UICollectionViewLayout, sizeForItemAt
     indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: profileSectionsCollectionView.frame.height)
     }
    
}

extension EditProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in profileSectionsCollectionView.view.visibleCells {
            if let row = profileSectionsCollectionView.view.indexPath(for: cell)?.item {
                dotView.updateIndex(newIndex: row)
            }
        }
    }
    
}
