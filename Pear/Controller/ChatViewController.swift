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
    private let sendMessageButton = UIButton()
    private let separatorView = UIView()

    // MARK: - Private Data Vars
    private let currentUser: User
    private let databaseRef = Database.database().reference()
    private var dateKeys: [Date] = []
    private var groupedMessagesByDate: [[PearMessage]] = []
    private var messages: [PearMessage] = []
    private let messageUser: MessageUser

    init(messageUser: MessageUser, currentUser: User) {
        self.messageUser = messageUser
        self.currentUser = currentUser
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

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .backgroundLightGreen
        // Hide navigation bar bottom shadow
        navigationController?.navigationBar.shadowImage = UIImage()
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

        setupChatInput()
        getChatMessages()
        setupConstraints(keyboardHeight: 0)
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
        let messagesPath = "user-messages/\(currentUser.netID)/\(messageUser.netID)"
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
        guard let recentDateMessagesCount = self.groupedMessagesByDate.last?.count else { return }
        let bottomRow = recentDateMessagesCount - 1
        self.chatTableView.reloadData()
        let bottomSection = self.groupedMessagesByDate.count - 1
        self.scrollToRow(row: bottomRow, section: bottomSection)
    }

    private func scrollToRow(row: Int, section: Int) {
        self.chatTableView.reloadData()
        let indexPath = IndexPath(row: row, section: section)
        if self.chatTableView.isValid(indexPath: indexPath) {
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    @objc private func sendMessage() {
        if let message = chatInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !message.isEmpty {
            addMessageToFirebase(message: message)
            chatInputTextField.text = ""
        }
    }

    @objc private func addMessageToFirebase(message: String) {
        let timeStamp = String(NSDate().timeIntervalSince1970)
        let values: [String: String] = [
            "senderNetID": currentUser.netID,
            "recipientNetID": messageUser.netID,
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
            let userMessagesPath = "user-messages/\(self.currentUser.netID)/\(self.messageUser.netID)"
            self.databaseRef.child(userMessagesPath).updateChildValues([messageId: 1])
            let pairMessagesPath = "user-messages/\(self.messageUser.netID)/\(self.currentUser.netID)"
            self.databaseRef.child(pairMessagesPath).updateChildValues([messageId: 1])
        }
    }

    @objc func hideKeyboard(notification: Notification) {
        setupConstraints(keyboardHeight: 0)
        guard let keyBoardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        UIView.animate(withDuration: keyBoardDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }

    private func setupConstraints(keyboardHeight: CGFloat) {
        let chatInputContainerHeight: CGFloat = 76
        let chatInputButtonSize: CGFloat = 25

        chatInputContainerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(chatInputContainerHeight)
            if keyboardHeight == 0 {
                make.bottom.equalTo(view.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(view.snp.bottom).offset(keyboardHeight - 5)
            }
        }

        chatTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
    }

}

extension ChatViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
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
        cell.selectionStyle = .none
        return cell
    }

}

extension ChatViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        groupedMessagesByDate[indexPath.section][indexPath.row].getMessageHeight(currentUserNetID: currentUser.netID)
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

