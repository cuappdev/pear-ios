//
//  AnswerPromptViewController.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/28/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class AnswerPromptViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let questionLabel = UILabel()
    private let responseTextView = UITextView()
    private let characterCountLabel = UILabel()
    private let saveButton = UIButton()

    // MARK: - Private Data Vars
    private var prompt: Prompt?

    init(prompt: Prompt) {
        super.init(nibName: nil, bundle: nil)
        self.prompt = prompt
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        titleLabel.text = "Enter your response"
        titleLabel.font = ._24CircularStdMedium
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        guard let selectedPrompt = prompt?.selectedPrompt else { return }
        questionLabel.text = selectedPrompt
        questionLabel.textColor = .greenGray
        questionLabel.numberOfLines = 0
        questionLabel.font = ._16CircularStdBook
        view.addSubview(questionLabel)

        responseTextView.delegate = self
        responseTextView.text = "Type your response..."
        responseTextView.textColor = .inactiveGreen
        responseTextView.font = ._16CircularStdBook
        responseTextView.layer.cornerRadius = 8
        responseTextView.layer.masksToBounds = true
        responseTextView.clipsToBounds = false
        responseTextView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        responseTextView.layer.shadowOpacity = 1
        responseTextView.layer.shadowRadius = 4
        responseTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(responseTextView)

        characterCountLabel.text = "150"
        characterCountLabel.textColor = .greenGray
        characterCountLabel.font = ._12CircularStdBook
        view.addSubview(characterCountLabel)

        if let promptResponse = prompt?.promptResponse {
            responseTextView.text = promptResponse
            characterCountLabel.text = "\(150 - promptResponse.count)"
        }

        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = ._20CircularStdBold
        saveButton.backgroundColor = .inactiveGreen
        saveButton.layer.cornerRadius = 26
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(saveButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        updateSave()
        setupConstraints()
    }

    private func updateSave() {
        saveButton.isEnabled = responseTextView.text.count > 0
        saveButton.backgroundColor = saveButton.isEnabled ? .backgroundOrange : .inactiveGreen
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveButtonPressed() {
        print("saving")
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupConstraints() {
        let questionLabelTopPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 40)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
            make.height.equalTo(61)
            make.width.equalTo(295)
            make.centerX.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
        }

        questionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(questionLabelTopPadding)
        }

        responseTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(questionLabel.snp.bottom).offset(12)
            make.height.equalTo(215)
        }

        characterCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(responseTextView)
            make.top.equalTo(responseTextView.snp.bottom).offset(10)
        }

        saveButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(responseTextView.snp.bottom).offset(60)
        }

    }

}

extension AnswerPromptViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text = "\(150 - textView.text.count)"
//        if !textView.text.isEmpty {
//            textView.textColor =
//        }
//        if textView.textColor == .inactiveGreen {
//            textView.text = ""
//            textView.textColor = .black
//        }
//        let characterCount = textView.text.count
//        characterCountLabel.text = "\(150 - characterCount)"
//        if textView.text.isEmpty {
//            textView.textColor = .inactiveGreen
//            textView.text = "Type your response..."
//        }
        updateSave()

    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .inactiveGreen
            textView.text = "Type your response..."
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .inactiveGreen {
            textView.text = ""
            textView.textColor = .black
        }
    }

}
