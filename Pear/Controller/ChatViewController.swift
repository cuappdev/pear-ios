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
    private var chatTableView = UITableView()
    private var chatInputContainerView = UIView()
    private var sendMessageButton = UIButton()
    private var chatInputTextField = UITextField()
    private var separatorView = UIView()

    // MARK: - Private Data Vars
    private var currentUser: User
    private let databaseRef = Database.database().reference()
    private var messageUser: MessageUser
    private var messages: [PearMessage] = []
    private var groupedMessagesByDate: [[PearMessage]] = []
    private var dateKeys: [Date] = []

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
        navigationController?.navigationBar.shadowImage = UIImage() // Hide navigation bar bottom shadow
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

    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func hideKeyboardWhenViewTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupChatInput() {
        chatInputContainerView.backgroundColor = .backgroundLightGreen
        view.addSubview(chatInputContainerView)

        chatInputTextField.attributedPlaceholder = NSAttributedString(string: "Say hi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.greenGray, NSAttributedString.Key.font: UIFont.getFont(.book, size: 16)])
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
        databaseRef.child("User-Messages").child(currentUser.netID).child(messageUser.netID).observe(.childAdded) { snapshot in
            let messageId = snapshot.key
            let messageRef = self.databaseRef.child("Messages").child(messageId)
            messageRef.observeSingleEvent(of: .value) { snapshot in
                self.getMessages(snapshot: snapshot)
            }
        }
    }

    private func getMessages(snapshot: DataSnapshot) {
        let message = PearMessage(snapshot: snapshot)
        self.messages.append(message)
        DispatchQueue.main.async {
            self.groupMessagesByDate()
        }
    }

    private func groupMessagesByDate() {
        self.groupedMessagesByDate = []
        let groupedMessages = Dictionary(grouping: messages) { message -> Date in
            var day = NSDate()
            if let timeSince1970 = Double(message.time) {
                day = NSDate(timeIntervalSince1970: timeSince1970)
            }
            var date = day as Date
            date = stripTimeOffDate(from: date)
            return date
        }

        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { key in
            let values = groupedMessages[key]
            self.groupedMessagesByDate.append(values ?? [])
        }

        dateKeys = sortedKeys

        guard var bottomRow = self.groupedMessagesByDate.last?.count else { return }
        bottomRow = bottomRow - 1
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            let bottomSection = self.groupedMessagesByDate.count - 1
            self.scrollToRow(row: bottomRow, section: bottomSection)
        }
    }

    private func scrollToRow(row: Int, section: Int) {
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            let indexPath = IndexPath(row: row, section: section)
            if self.chatTableView.validIndexPath(indexPath: indexPath) {
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    private func stripTimeOffDate(from originalDate: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: originalDate)
        let date = Calendar.current.date(from: components)
        return date!
    }

    @objc private func sendMessage() {
        if let message = chatInputTextField.text, !message.isEmpty {
            let messageData = ["message": message]
            addMessageToFirebase(data: messageData)
            chatInputTextField.text = ""
        }
    }

    @objc private func addMessageToFirebase(data: [String: Any]) {
        let timeStamp = String(NSDate().timeIntervalSince1970)
        var values: [String: Any] = [
            "senderNetID": currentUser.netID,
            "recipientNetID": messageUser.netID,
            "time": timeStamp
        ]
        data.forEach { (key, value) in
            values[key] = value
        }
        let messageDatabaseRef = databaseRef.child("Messages").childByAutoId()
        messageDatabaseRef.updateChildValues(values) { error, reference in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let messageId = messageDatabaseRef.key else { return }
            let userMessagesRef = self.databaseRef.child("User-Messages").child(self.currentUser.netID).child(self.messageUser.netID)
            userMessagesRef.updateChildValues([messageId: 1])
            let pairMessagesref = self.databaseRef.child("User-Messages").child(self.messageUser.netID).child(self.currentUser.netID)
            pairMessagesref.updateChildValues([messageId: 1])
        }
    }

    @objc func hideKeyboard(notification: Notification) {
        setupConstraints(keyboardHeight: 0)
        guard let keyBoardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        UIView.animate(withDuration: keyBoardDuration, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func setupConstraints(keyboardHeight: CGFloat) {
        let chatInputContainerHeight: CGFloat = 76
        let chatInputButtonSize:CGFloat = 25

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
        dateLabel.setDateString(section: section, dateKeys: dateKeys)
        containerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(containerView.snp.centerX)
            make.centerY.equalTo(containerView.snp.centerY)
        }

        return containerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseId, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        let message = groupedMessagesByDate[indexPath.section][indexPath.row]
        cell.configure(for: message, user: currentUser, pair: messageUser)
        cell.selectionStyle = .none
        return cell
    }

}

extension ChatViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = groupedMessagesByDate[indexPath.section][indexPath.row]
        return message.getMessageHeight(currentUserNetID: currentUser.netID)
    }

}

extension ChatViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }

}
