//
//  PromptAnswersSettingsViewController.swift
//  Pear
//
//  Created by Tiffany Pan on 10/20/22.
//  Copyright © 2022 cuappdev. All rights reserved.
//

import UIKit

class PromptAnswersSettingsViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let characterCountLabel = UILabel()
    private let questionLabel = UILabel()
    private let responseTextView = UITextView()
    private let saveButton = DynamicButton()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private var addPrompt: (Prompt, Int) -> ()
    private var index: Int
    private let maxCharacters = 150
    private var prompt: Prompt
    private var delegate: EditProfileDelegate?
    private var updatingUser: UserV2
    
    init(updatingUser: UserV2, delegate: EditProfileDelegate, prompt: Prompt, addPrompt: @escaping (Prompt, Int) -> (), index: Int) {
        self.updatingUser = updatingUser
        self.delegate = delegate
        self.prompt = prompt
        self.addPrompt = addPrompt
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.isNavigationBarHidden = true
        
        setupView()
        setupTitleLabel()
        setupBackButton()
        setupQuestionLabel()
        setupResponseTextView()
        setupCharacterCountView()
        setupSaveButtonView()

        if let promptResponse = prompt.answer, !promptResponse.isEmpty {
            responseTextView.text = promptResponse
            responseTextView.textColor = .black
            characterCountLabel.text = "\(maxCharacters - promptResponse.count)"
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        updateSave()
        
    }

    private func updateSave() {
        saveButton.isEnabled = responseTextView.text.count > 0 && responseTextView.text != prompt.questionPlaceholder
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveButtonPressed() {
        if let answer = responseTextView.text {
            let newPrompt = Prompt(id: prompt.id, questionName: prompt.questionName, questionPlaceholder: prompt.questionPlaceholder, answer: answer)
            updatingUser.prompts[index] = newPrompt
            delegate?.updatePrompts(updatedUser: updatingUser, newPrompt: prompt)
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    private func setupView() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Enter your response"
        titleLabel.font = ._24CircularStdMedium
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
            make.size.equalTo(CGSize(width: 295, height: 61))
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
        }
    }
    
    private func setupQuestionLabel() {
        let questionLabelTopPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 40)
        questionLabel.text = prompt.questionName
        questionLabel.textColor = .darkGreen
        questionLabel.numberOfLines = 0
        questionLabel.font = ._16CircularStdBook
        view.addSubview(questionLabel)
        
        questionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(questionLabelTopPadding)
        }
    }
    
    private func setupResponseTextView() {
        responseTextView.delegate = self
        responseTextView.text = prompt.questionPlaceholder
        responseTextView.textColor = .inactiveGreen
        responseTextView.font = ._16CircularStdBook
        responseTextView.returnKeyType = .default
        responseTextView.layer.cornerRadius = 8
        responseTextView.layer.masksToBounds = true
        responseTextView.clipsToBounds = true
        responseTextView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        responseTextView.layer.shadowOpacity = 1
        responseTextView.layer.shadowRadius = 4
        responseTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
        responseTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        view.addSubview(responseTextView)
        
        responseTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(questionLabel.snp.bottom).offset(12)
            make.height.equalTo(215)
        }
    }
    
    private func setupCharacterCountView() {
        characterCountLabel.text = "\(maxCharacters)"
        characterCountLabel.textColor = .darkGreen
        characterCountLabel.font = ._12CircularStdBook
        view.addSubview(characterCountLabel)
        
        characterCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(responseTextView)
            make.top.equalTo(responseTextView.snp.bottom).offset(10)
        }
    }
    
    private func setupSaveButtonView() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = ._20CircularStdBold
        saveButton.layer.cornerRadius = Constants.Onboarding.mainButtonSize.height / 2
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(responseTextView.snp.bottom).offset(60)
        }
    }
}

extension PromptAnswersSettingsViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text = "\(maxCharacters - textView.text.count)"
        updateSave()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .inactiveGreen
            textView.text = prompt.questionPlaceholder
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .inactiveGreen {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= maxCharacters
    }

}

extension PromptAnswersSettingsViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UITextView)
    }

}

