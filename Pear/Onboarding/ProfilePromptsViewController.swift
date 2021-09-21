//
//  ProfilePromptsViewController.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 8/17/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

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
    private var promptOptions: [Prompt] = []

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
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        getUserPrompts()
        setPromptOptions()
        setupConstraints()
    }

    private func getUserPrompts() {
        NetworkManager.getCurrentUser { result in
            switch result {
            case .success(let user):
                self.prompts = user.prompts
                while self.prompts.count < 3 {
                    self.prompts.append(Prompt(id: nil, questionName: "", questionPlaceholder: "", answer: nil))
                }
                self.updateNext()
                self.fadeTableView.view.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func setPromptOptions() {
        NetworkManager.getPromptOptions { prompts in
            DispatchQueue.main.async {
                self.promptOptions = prompts
            }
        }
    }

    private func updateNext() {
        nextButton.isEnabled = !prompts.compactMap(\.answer).isEmpty
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
    }

    @objc private func backButtonPressed() {
        delegate?.backPage(index: 2)
    }

    @objc private func nextButtonPressed() {
        NetworkManager.updatePrompts(prompts: prompts) { success in
            DispatchQueue.main.async {
                if success {
                    self.delegate?.nextPage(index: 4)
                } else {
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
    }

    private func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
            make.size.equalTo(CGSize(width: 295, height: 61))
            make.centerX.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 295, height: 34))
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        fadeTableView.snp.makeConstraints { make in
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
        if let answer = prompt.answer, !answer.isEmpty {
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
        cell.removePrompt = { [weak self] selectedCell in
            guard let self = self else { return }
            guard let indexPath = self.fadeTableView.view.indexPath(for: cell) else { return }
            self.prompts[indexPath.row] = Prompt(id: nil, questionName: "", questionPlaceholder: "", answer: nil)
            NetworkManager.getPromptOptions { prompts in
                DispatchQueue.main.async {
                    self.promptOptions = prompts.filter { !self.prompts.contains($0) }
                    self.updateNext()
                    self.fadeTableView.view.reloadData()
                }
            }
        }
        return cell
    }

}

extension ProfilePromptsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prompt = prompts[indexPath.row]
        let answer = prompt.answer ?? ""
        if !answer.isEmpty {
            let answerPromptViewController = AnswerPromptViewController(prompt: prompt, addPrompt: { (prompt, index) in
                self.updateProfilePrompt(prompt: prompt, index: index)
            }, index: indexPath.row)
            navigationController?.pushViewController(answerPromptViewController, animated: true)
        } else {
            let selectPromptViewController = SelectPromptViewController(prompts: promptOptions, addPrompt: { (prompt, index) in
                self.updateProfilePrompt(prompt: prompt, index: index)
            }, index: indexPath.row)
            navigationController?.pushViewController(selectPromptViewController, animated: true)
        }
    }

    private func updateProfilePrompt(prompt: Prompt, index: Int) {
        self.prompts[index] = prompt
        self.promptOptions = self.promptOptions.filter{ $0.id != prompt.id }
        self.updateNext()
        self.fadeTableView.view.reloadData()
    }

}
