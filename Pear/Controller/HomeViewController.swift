//
//  HomeViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//
import FutureNova
import Kingfisher
import SideMenu
import UIKit
import UserNotifications
import AppDevAnnouncements

class HomeViewController: UIViewController {

    // MARK: - Private View Vars
    private var feedbackButton = UIButton()
    private var feedbackMenuView: FeedbackView?
    private let profileImageView = UIImageView()
    /// Pill display used to swap between matching and community view controllers
    private var tabCollectionView: UICollectionView!
    /// View that holds `tabPageViewController` below the pill view
    private var tabContainerView: UIView!
    /// View Controller whose contents are shown below
    private var tabPageViewController: TabPageViewController?
    private let profileButtonSize = CGSize(width: 35, height: 35)

    // MARK: - Private Data Vars
    private var activeTabIndex = 0
    private let tabs = ["Weekly Pear", "People"]
    private var user: User?
    private var displayMenu = true

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

        feedbackButton.setImage(UIImage(named: "menuicon"), for: .normal)
        feedbackButton.addTarget(self, action: #selector(toggleFeedbackMenu), for: .touchUpInside)
        view.addSubview(feedbackButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

//        TODO: uncomment when feedback route is done
//        showInAppFeedback()
        setupLocalNotifications()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        updateUserAndTabPage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func showInAppFeedback() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getMatchHistory(netID: netId).observe { response in
            switch response {
            case .value(let currentMatchHistory):
                guard currentMatchHistory.success else {
                    print("Network error: could not get user match history")
                    return
                }
                var previousMatchHistorySize = UserDefaults.standard.integer(forKey: Constants.UserDefaults.previousMatchHistorySize)
                // the default value for previousMatchHistorySize is 0, but it should be 1 since the app feedback form should only be shown when the user has a match history of size 2 or more
                previousMatchHistorySize = previousMatchHistorySize == 0 ? 1 : previousMatchHistorySize
                if currentMatchHistory.data.count > previousMatchHistorySize {
                    DispatchQueue.main.async {
                        let navController = UINavigationController(rootViewController: FeedbackViewController())
                        navController.modalPresentationStyle = .overFullScreen
                        self.present(navController, animated: true)
                    }
                }
            case .error(let error):
                print("error: \(error)")
            }
        }
    }

    private func updateUserAndTabPage() {
        getUserThen { [weak self] newUser in
            guard let self = self else { return }
            self.getUserMatchThen(netId: newUser.netID) { [weak self] matches in
                guard let self = self else { return }
                if self.user == nil || self.user != newUser {
                    let firstActiveMatch = matches.filter({ $0.status != "inactive" }).first
                    self.setUserAndTabPage(newUser: newUser, match: firstActiveMatch)
                }
            }
        }
    }

    private func setUserAndTabPage(newUser: User, match: Match? = nil) {
        user = newUser
        profileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: newUser.profilePictureURL, cacheKey: newUser.netID))
        setupTabPageViewController(with: match, user: newUser)
    }

    private func getUserThen(_ completion: @escaping (User) -> Void) {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getUser(netId: netId).observe { result in
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    guard response.success else {
                        print("Network error: could not get user.")
                        return
                    }
                    completion(response.data)
                case .error:
                    print("Network error: could not get user.")
                }
            }
        }
    }

    private func getUserMatchThen(netId: String, completion: @escaping ([Match]) -> Void) {
        NetworkManager.shared.getUserMatches(netId: netId).observe { result in
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    guard response.success else {
                        print("Network error: could not get user match.")
                        return
                    }
                    completion(response.data)
                case .error:
                    print("Network error: could not get user match.")
                }

            }
        }
    }

    private func setupTabPageViewController(with match: Match? = nil, user: User) {
        tabPageViewController = TabPageViewController(match: match, user: user)
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
        let menu = SideMenuNavigationController(rootViewController: ProfileMenuViewController(user: user))
        let presentationStyle: SideMenuPresentationStyle = .viewSlideOutMenuPartialIn
        presentationStyle.presentingEndAlpha = 0.85
        menu.presentationStyle = .viewSlideOutMenuPartialIn
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
        if displayMenu {
            feedbackMenuView = FeedbackView()
            guard let feedbackMenuView = feedbackMenuView else { return }
            feedbackMenuView.layer.cornerRadius = 20
            view.addSubview(feedbackMenuView)

            feedbackMenuView.snp.makeConstraints { make in
                make.top.equalTo(feedbackButton.snp.bottom).offset(5)
                make.trailing.equalTo(view.snp.trailing).offset(-25)
                make.size.equalTo(CGSize(width: 150, height: 130))
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
        activeTabIndex = indexPath.item
        tabPageViewController?.setViewController(to: indexPath.item)
        tabCollectionView.reloadData()
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
        cell.isSelected = indexPath.item == activeTabIndex
        cell.configure(with: tabs[indexPath.item])
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
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                center.delegate = self
                // get rid of previously scheduled notifications
                center.removeAllDeliveredNotifications()
                center.removeAllPendingNotificationRequests()
                self.scheduleNotifications(center: center, day: 2, hour: 8, title: "Meet your new pear!", body: "Set up this week's chat today 😊")
                self.scheduleNotifications(center: center, day: 4, hour: 14, title: "Did you reach out yet?", body: "Choose a meeting time with your Pear before it's too late!")
                self.scheduleNotifications(center: center, day: 6, hour: 12, title: "How's it going?", body: "New pairings will come out next week! ⌚️")
            }
        }
    }

    private func scheduleNotifications(center: UNUserNotificationCenter, day: Int, hour: Int, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let dateComponents = DateComponents(hour: hour, minute: 0, second: 0, weekday: day)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        center.add(request)
    }
}
