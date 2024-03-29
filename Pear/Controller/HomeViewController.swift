//
//  HomeViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//
import AppDevAnnouncements
import FirebaseMessaging
import Kingfisher
import SafariServices
import SideMenu
import UIKit
import UserNotifications

class HomeViewController: UIViewController {

    // MARK: - Private View Vars
    private var feedbackButton = UIButton()
    private var feedbackMenuView: OptionsView?
    private let profileImageView = UIImageView()
    /// Pill display used to swap between matching and community view controllers
    private var tabCollectionView: UICollectionView!
    /// View that holds `tabPageViewController` below the pill view
    private var tabContainerView: UIView!
    /// View Controller whose contents are shown below
    private var tabPageViewController: TabPageViewController?

    // MARK: - Private Data Vars
    private var activeTabIndex = 0
    private var displayMenu = true
    private let profileButtonSize = CGSize(width: 35, height: 35)
    private let tabs = ["Weekly Pear", "People"]
    private var menuOptions = ["Send feedback", "Contact us", "Report user"]
    private let matchOptions = ["Send feedback", "Contact us", "Report user", "Block user"]
    private let communityOptions = ["Send feedback", "Contact us", "Report user"]
    private var user: UserV2?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        presentAnnouncement(completion: nil)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profilePressed))
        profileImageView.layer.backgroundColor = UIColor.inactiveGreen.cgColor
        profileImageView.layer.cornerRadius = profileButtonSize.width / 2
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        profileImageView.layer.shadowOpacity = 0.15
        profileImageView.layer.shadowRadius = 2
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(profileImageView)

        tabContainerView = UIView()
        view.addSubview(tabContainerView)

        let tabLayout = UICollectionViewFlowLayout()
        tabLayout.minimumInteritemSpacing = 0

        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tabLayout)
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(HomeTabOptionCollectionViewCell.self,
                                   forCellWithReuseIdentifier: HomeTabOptionCollectionViewCell.reuseIdentifier)
        tabCollectionView.backgroundColor = .white
        tabCollectionView.clipsToBounds = true
        tabCollectionView.layer.masksToBounds = false
        tabCollectionView.layer.cornerRadius = 20
        tabCollectionView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        tabCollectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabCollectionView.layer.shadowOpacity = 1
        tabCollectionView.layer.shadowRadius = 4
        view.addSubview(tabCollectionView)

        feedbackButton.setImage(UIImage(named: "infoIcon"), for: .normal)
        feedbackButton.addTarget(self, action: #selector(toggleFeedbackMenu), for: .touchUpInside)
        feedbackButton.contentHorizontalAlignment = .fill
        feedbackButton.contentVerticalAlignment = .fill
        view.addSubview(feedbackButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

        setupLocalNotifications()
        setupConstraints()
        setupUserLicenseAgreementView()
        updateUserAndTabPage()
        getToken()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func showInAppFeedback() {
        guard let user = user, let matchId = user.currentMatch?.id else { return }
        if user.pendingFeedback {
            let navController = UINavigationController(rootViewController: FeedbackViewController(matchId: matchId))
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true)
        }
    }
    
    private func updateUserAndTabPage() {
        NetworkManager.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.user = user
                    if let profilePictureURL = URL(string: user.profilePicUrl) {
                        self.profileImageView.kf.setImage(with: profilePictureURL)
                    }
                    self.setupTabPageViewController(user: user)
                    self.showInAppFeedback()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func setupTabPageViewController(user: UserV2) {
        tabPageViewController = TabPageViewController(user: user, tabDelegate: self, profileDelegate: self)
        if let tabPageViewController = tabPageViewController {
            addChild(tabPageViewController)
            tabPageViewController.view.frame = tabContainerView.frame
            tabContainerView.addSubview(tabPageViewController.view)
            tabPageViewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        view.updateConstraints()
    }

    @objc private func profilePressed() {
        presentMenu(animated: true)
    }

    private func presentMenu(animated: Bool) {
        guard let user = user else { return }
        let profileMenuVC = ProfileMenuViewController(user: user)
        profileMenuVC.delegate = self
        let menu = SideMenuNavigationController(rootViewController: profileMenuVC)
        let presentationStyle: SideMenuPresentationStyle = .viewSlideOutMenuPartialIn
        presentationStyle.presentingEndAlpha = 0.85
        menu.presentationStyle = presentationStyle
        menu.leftSide = true
        menu.statusBarEndAlpha = 0
        menu.menuWidth = view.frame.width * 0.8
        present(menu, animated: animated)
    }

    @objc private func dismissMenu() {
        if !displayMenu {
            feedbackMenuView?.removeFromSuperview()
            displayMenu.toggle()
        }
    }

    @objc private func toggleFeedbackMenu() {
        let feedbackMenuViewSize = CGSize(width: 150, height: 43 * menuOptions.count)
        let feedbackMenuViewPadding = 5
        
        if displayMenu {
            guard let user = user, let superView = navigationController?.view else { return }
            feedbackMenuView = OptionsView(
                feedbackDelegate: self,
                blockDelegate: self,
                matchId: user.currentMatch?.id ?? 0,
                blockId: user.currentMatch?.matchedUser.id ?? 0,
                options: menuOptions,
                superView: superView
            )
            guard let feedbackMenuView = feedbackMenuView else { return }
            view.addSubview(feedbackMenuView)

            feedbackMenuView.snp.makeConstraints { make in
                make.top.equalTo(feedbackButton.snp.bottom).offset(feedbackMenuViewPadding)
                make.trailing.equalTo(view.snp.trailing).inset(5 * feedbackMenuViewPadding)
                make.size.equalTo(feedbackMenuViewSize)
            }
        } else {
            feedbackMenuView?.removeFromSuperview()
        }
        displayMenu.toggle()
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(tabCollectionView)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(profileButtonSize)
        }

        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.size.equalTo(CGSize(width: 227, height: 40))
            make.centerX.equalToSuperview()
        }

        feedbackButton.snp.makeConstraints { make in
            make.centerY.equalTo(tabCollectionView)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }

        tabContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tabCollectionView.snp.bottom)
        }
    }

}

extension HomeViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIButton)
    }
    
}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setActiveTabIndex(to: indexPath.item)
    }

}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTabOptionCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as?
                HomeTabOptionCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: tabs[indexPath.item], isSelected: indexPath.item == activeTabIndex)
        return cell
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = indexPath.item == 0 ? 151 : 50
        return CGSize(width: cellWidth, height: 40)
    }

} 

extension HomeViewController: UNUserNotificationCenterDelegate {
    private func setupLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                center.delegate = self
                // TODO: get rid of previously scheduled notifications
//                self.scheduleNotifications(center, day: 2, hour: 8, title: "Meet your new pear!", body: "Set up this week's chat today 😊", aboutPear: true)
//                self.scheduleNotifications(center, day: 4, hour: 14, title: "Did you reach out yet?", body: "Choose a meeting time with your Pear before it's too late!", aboutPear: true)
//                self.scheduleNotifications(center, day: 6, hour: 12, title: "How's it going?", body: "New pairings will come out next week! ⌚️", aboutPear: true)
//                self.scheduleNotifications(center, day: 0, hour: 0, title: "Are you running the latest version of Pear?", body: "Open TestFlight to check for new updates", aboutPear: false)
            }
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }

    private func scheduleNotifications(_ center: UNUserNotificationCenter, day: Int, hour: Int, title: String, body: String, aboutPear: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let dateComponents = DateComponents(hour: hour, minute: 0, second: 0, weekday: day)
        let trigger = aboutPear
            ? UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            : UNTimeIntervalNotificationTrigger(timeInterval: Constants.Notifications.checkBuildNotifInterval, repeats: true)
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        center.add(request)
    }
    
    private func getToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let token = token else { return }
            
            NetworkManager.updateFCMToken(token: token)
        }
    }
}

extension HomeViewController: FeedbackDelegate {
    func presentActionSheet(alert: UIAlertController) {
        present(alert, animated: true)
    }
}

extension HomeViewController: TabDelegate {

    func setActiveTabIndex(to index: Int) {
        activeTabIndex = index
        tabPageViewController?.setViewController(to: index)
        if let _ = user?.currentMatch, index == 0 {
            menuOptions = matchOptions
        } else {
            menuOptions = communityOptions
        }
        tabCollectionView.reloadData()
    }
    
}

extension HomeViewController: ProfileMenuDelegate {
    
    func didUpdateProfilePicture(image: UIImage?, url: String) {
        profileImageView.image = image
        user?.profilePicUrl = url
    }
    func didUpdateProfileDemographics() {
        updateUserAndTabPage()
    }
    
}

extension HomeViewController: BlockDelegate {
    
    func didBlockOrUnblockUser() {
        updateUserAndTabPage()
    }
    
    func presentErrorAlert() {
        present(UIAlertController.getStandardErrortAlert(), animated: true)
    }
    
}

extension HomeViewController: UserAgreementDelegate {
    func setupUserLicenseAgreementView() {
        let endUserLicenseAgreementView = EndUserLicenseAgreementView(delegate: self)
        let hasAcceptedTerms = UserDefaults.standard.bool(forKey: Constants.UserDefaults.userHasAcceptedTerms)
        if !hasAcceptedTerms {
            Animations.presentPopUpView(superView: view, popUpView: endUserLicenseAgreementView)
        }
    }
    
    func presentUserLicenseAgreementWebView(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .overCurrentContext
        present(safariVC, animated: true, completion: nil)
    }
    
}
