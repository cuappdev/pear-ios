//
//  ProfilePromptsViewController.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/27/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

protocol AddProfilePromptDelegate: class {
    func addPrompt(prompt: Prompt, index: Int)
}

protocol RemoveProfilePromptDelegate: class {
    func removePrompt(cell: PromptTableViewCell)
}

class ProfilePromptsViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let nextButton = UIButton()
    private let fadeTableView = FadeWrapperView(
        UITableView(),
        fadeColor: .backgroundLightGreen
    )

    // MARK: - Private Data Vars
    private weak var delegate: OnboardingPageDelegate?
    private var prompts: [Prompt] = []
    private var promptOptions = Constants.Options.profilePrompts.map { Prompt(didAnswerPrompt: false, promptResponse: nil, promptQuestion: $0) }

    init(delegate: OnboardingPageDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        // TODO: change when networking with backend
        prompts = [Prompt(didAnswerPrompt: false, promptResponse: nil, promptQuestion: nil), Prompt(didAnswerPrompt: false, promptResponse: nil, promptQuestion: nil), Prompt(didAnswerPrompt: false, promptResponse: nil, promptQuestion: nil)]

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        titleLabel.text = "Let’s get to know you\nbetter!"
        titleLabel.textColor = .black
        titleLabel.font = ._24CircularStdMedium
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        subtitleLabel.text = "Answer three prompts to share a little bit about\nwho you are"
        subtitleLabel.font = ._12CircularStdBook
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .darkGreen
        view.addSubview(subtitleLabel)

        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.backgroundColor = .clear
        fadeTableView.view.keyboardDismissMode = .onDrag
        fadeTableView.view.separatorStyle = .none
        fadeTableView.view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 50, right: 0)
        fadeTableView.view.delegate = self
        fadeTableView.view.rowHeight = UITableView.automaticDimension
        fadeTableView.view.estimatedRowHeight = 140
        fadeTableView.view.dataSource = self
        fadeTableView.view.register(PromptTableViewCell.self, forCellReuseIdentifier: PromptTableViewCell.reuseIdentifier)
        fadeTableView.view.separatorColor = .clear
        view.addSubview(fadeTableView)

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = 26
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        setupConstraints()
    }

    private func updateNext() {
        nextButton.isEnabled = prompts.filter{ $0.didAnswerPrompt }.count == 3
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
    }

    @objc private func backButtonPressed() {
        delegate?.backPage(index: 2)
    }

    @objc private func nextButtonPressed() {
        // TODO - update prompt values in backend
        self.delegate?.nextPage(index: 4)
    }

    private func setupConstraints() {

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

        subtitleLabel.snp.makeConstraints { make in
            make.width.equalTo(titleLabel)
            make.height.equalTo(34)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        fadeTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(48)
            make.bottom.equalTo(nextButton.snp.top).offset(-57)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(28)
        }

        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }

    }

}

extension ProfilePromptsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let prompt = prompts[indexPath.row]
        if prompt.didAnswerPrompt {
            return UITableView.automaticDimension
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        prompts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.reuseIdentifier, for: indexPath) as? PromptTableViewCell else { return UITableViewCell() }
        let prompt = prompts[indexPath.row]
        cell.configure(for: prompt)
        cell.delegate = self
        return cell
    }

}

extension ProfilePromptsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prompt = prompts[indexPath.row]
        if prompt.didAnswerPrompt {
            navigationController?.pushViewController(AnswerPromptViewController(prompt: prompt, delegate: self, index: indexPath.row), animated: true)
        } else {
            navigationController?.pushViewController(SelectPromptViewController(prompts: promptOptions, delegate: self, index: indexPath.row), animated: true)
        }
    }

}

extension ProfilePromptsViewController: AddProfilePromptDelegate {

    func addPrompt(prompt: Prompt, index: Int) {
        prompts[index] = prompt
        promptOptions = promptOptions.filter{ $0.promptQuestion != prompt.promptQuestion }
        updateNext()
        fadeTableView.view.reloadData()
    }

}

extension ProfilePromptsViewController: RemoveProfilePromptDelegate {

    func removePrompt(cell: PromptTableViewCell) {
        guard let indexPath = fadeTableView.view.indexPath(for: cell) else { return }
        prompts[indexPath.row] = Prompt(didAnswerPrompt: false, promptResponse: nil, promptQuestion: nil)
        promptOptions = Constants.Options.profilePrompts.map { Prompt(didAnswerPrompt: false, promptResponse: nil, promptQuestion: $0) }.filter { !prompts.contains($0) }
        updateNext()
        fadeTableView.view.reloadData()
    }

}
