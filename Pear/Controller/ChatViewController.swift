//
//  ChatViewController.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 5/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Firebase
import SnapKit
import UIKit

class ChatViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let chatInputContainerView = UIView()
    private let chatInputTextField = UITextField()
    private let chatTableView = UITableView()
    private let emptyBackgroundView = UIView()
    private let emptyChatImage = UIImageView()
    private let sendMessageButton = UIButton()
    private let separatorView = UIView()

    // MARK: - Private Data Vars
    private let currentUser: UserV2
    private let databaseRef = Database.database().reference()
    private var dateKeys: [Date] = []
    private var groupedMessagesByDate: [[PearMessage]] = []
    private var messages: [PearMessage] = []
    private let messageUser: MatchedUser
    private let status: String

    init(messageUser: MatchedUser, currentUser: UserV2, status: String) {
        self.messageUser = messageUser
        self.currentUser = currentUser
        self.status = status
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat with \(messageUser.firstName)"
        view.backgroundColor = .backgroundLightGreen

        hideKeyboardWhenViewTapped()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(.medium, size: 24)
        ]
        
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .backgroundLightGreen
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseId)
        chatTableView.dataSource = self
        chatTableView.delegate = self
        view.addSubview(chatTableView)

        emptyChatImage.image = UIImage(named: "emptyChat")
        emptyChatImage.contentMode = .scaleAspectFit

        emptyBackgroundView.backgroundColor = .clear
        emptyBackgroundView.addSubview(emptyChatImage)

        setupChatInput()
        getChatMessages()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func hideKeyboardWhenViewTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupChatInput() {
        chatInputContainerView.backgroundColor = .backgroundLightGreen
        view.addSubview(chatInputContainerView)

        chatInputTextField.attributedPlaceholder = NSAttributedString(
            string: "Say hi",
            attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.greenGray,
            NSAttributedString.Key.font: UIFont.getFont(.book, size: 16)
            ]
        )
        chatInputTextField.layer.cornerRadius = 12
        chatInputTextField.backgroundColor = .white
        chatInputTextField.delegate = self
        chatInputContainerView.addSubview(chatInputTextField)

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        chatInputTextField.leftView = leftPaddingView
        chatInputTextField.leftViewMode = .always

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        chatInputTextField.rightView = rightPaddingView
        chatInputTextField.rightViewMode = .always

        sendMessageButton.setImage(UIImage(named: "sendMessage"), for: .normal)
        sendMessageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        chatInputContainerView.addSubview(sendMessageButton)

        separatorView.backgroundColor = .inactiveGreen
        chatInputContainerView.addSubview(separatorView)
    }

    private func getChatMessages() {
        let messagesPath = "user-messages/\(currentUser.id)/\(messageUser.id)"
        databaseRef.child(messagesPath).observe(.childAdded) { snapshot in
            let messageId = snapshot.key
            let messageRef = self.databaseRef.child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value) { snapshot in
                if let snapshotValue = snapshot.value as? [String: Any] {
                    let message = PearMessage(snapshot: snapshotValue)
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.groupMessagesByDate()
                    }
                }
            }
        }
    }

    private func groupMessagesByDate() {
        groupedMessagesByDate = []
        let groupedMessages = Dictionary(grouping: messages) { message -> Date in
            var date = NSDate()
            if let timeSince1970 = Double(message.time) {
                date = NSDate(timeIntervalSince1970: timeSince1970)
            }
            return Time.stripTimeOff(from: date as Date)
        }

        dateKeys = groupedMessages.keys.sorted()
        dateKeys.forEach { key in
            let values = groupedMessages[key]
            groupedMessagesByDate.append(values ?? [])
        }
        
        chatTableView.reloadData()
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        let lastSection = chatTableView.numberOfSections - 1
        let lastRow = chatTableView.numberOfRows(inSection: lastSection) - 1
        let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
        
        guard chatTableView.isValid(indexPath: lastIndexPath) else { return }
        
        chatTableView.layoutIfNeeded()
        
        chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
    }

    @objc private func sendMessage() {
        guard let message = chatInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        guard !message.isEmpty else {
            return
        }
        
        addMessageToFirebase(message: message)
        chatInputTextField.text = ""
        
        let isPastPear = (status == Constants.Match.canceled || status == Constants.Match.inactive) ? true : false
        
        if isPastPear {
            Analytics.logEvent(Constants.Analytics.sentMessagePrevious, parameters: nil)
        } else {
            Analytics.logEvent(Constants.Analytics.sentMessageCurrent, parameters: nil)
        }
    }

    @objc private func addMessageToFirebase(message: String) {
        let timeStamp = String(NSDate().timeIntervalSince1970)
        let values: [String: Any] = [
            "senderId": currentUser.id,
            "recipientId": messageUser.id,
            "time": timeStamp,
            "message": message
        ]
        let messageDatabaseRef = databaseRef.child("messages").childByAutoId()
        messageDatabaseRef.updateChildValues(values) { error, reference in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let messageId = messageDatabaseRef.key else { return }
            let userMessagesPath = "user-messages/\(self.currentUser.id)/\(self.messageUser.id)"
            self.databaseRef.child(userMessagesPath).updateChildValues([messageId: 1])
            let pairMessagesPath = "user-messages/\(self.messageUser.id)/\(self.currentUser.id)"
            self.databaseRef.child(pairMessagesPath).updateChildValues([messageId: 1])
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    private func setupConstraints() {
        let chatInputContainerHeight: CGFloat = 76
        let chatInputButtonSize: CGFloat = 25

        chatInputContainerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(chatInputContainerHeight)
            make.bottom.equalToSuperview().inset(40)
        }

        chatTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(chatInputContainerView.snp.top)
        }

        sendMessageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(28)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(chatInputButtonSize)
        }

        chatInputTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalTo(sendMessageButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }

        emptyChatImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(45)
            make.center.equalToSuperview()
            make.height.equalTo(200)
        }
    }

}

extension ChatViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView = groupedMessagesByDate.count > 0 ? nil : emptyBackgroundView
        return groupedMessagesByDate.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedMessagesByDate[section].count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        let dateLabel = ChatDateHeaderLabel()
        let date = dateKeys[section]
        dateLabel.setDateString(date: date)
        containerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(containerView.snp.centerX)
            make.centerY.equalTo(containerView.snp.centerY)
        }

        return containerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            ChatTableViewCell.reuseId,
            for: indexPath
        ) as? ChatTableViewCell else { return UITableViewCell() }
        let message = groupedMessagesByDate[indexPath.section][indexPath.row]
        cell.configure(for: message, user: currentUser, pair: messageUser)
        cell.viewProfile = {
            self.navigationController?.pushViewController(ProfileViewController(userId: self.messageUser.id), animated: true)
        }
        cell.selectionStyle = .none
        return cell
    }

}

extension ChatViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        groupedMessagesByDate[indexPath.section][indexPath.row].getMessageHeight(currentUserId: currentUser.id)
    }

}

extension ChatViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }

}

extension ChatViewController: UIGestureRecognizerDelegate {

      func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
         if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
             navigationController?.popViewController(animated: true)
         } else if gestureRecognizer.view == view {
            return true
         }
         return false
     }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !(touch.view is UIButton)
    }

}

