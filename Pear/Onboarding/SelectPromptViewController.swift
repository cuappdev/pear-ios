//
//  SelectPromptViewController.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 8/17/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

class SelectPromptViewController: UIViewController {

    // MARK: Private View Vars
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let fadeTableView = FadeWrapperView(
        UITableView(),
        fadeColor: .backgroundLightGreen
    )

    // MARK: Private Data Vars
    // TODO: change when networking done with backend
    private var prompts: [Prompt]
    private var index: Int
    private var addPrompt: (Prompt, Int) -> ()

    init(prompts: [Prompt], addPrompt: @escaping (Prompt, Int) -> (), index: Int) {
        self.prompts = prompts
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
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        fadeTableView.view.clipsToBounds = true
        fadeTableView.view.backgroundColor = .none
        fadeTableView.view.keyboardDismissMode = .onDrag
        fadeTableView.view.separatorStyle = .none
        fadeTableView.view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
        fadeTableView.view.delegate = self
        fadeTableView.view.dataSource = self
        fadeTableView.view.register(SelectPromptTableViewCell.self, forCellReuseIdentifier: SelectPromptTableViewCell.reuseIdentifier)
        view.addSubview(fadeTableView)

        titleLabel.text = "Select a prompt"
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        setupConstraints()
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func setupConstraints() {
        let tableViewTopPadding = LayoutHelper.shared.getCustomVerticalPadding(size: 48)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Onboarding.titleLabelPadding)
        }

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        fadeTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(tableViewTopPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(57)
        }
    }

}

extension SelectPromptViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prompts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectPromptTableViewCell.reuseIdentifier, for: indexPath) as? SelectPromptTableViewCell else { return UITableViewCell() }
        let prompt = prompts[indexPath.row]
        cell.configure(for: prompt)
        return cell
    }

}

extension SelectPromptViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prompt = prompts[indexPath.row]
        let answerPromptViewController = AnswerPromptViewController(prompt: prompt, addPrompt: { (prompt, index) in
            self.addPrompt(prompt, index)
            self.navigationController?.popViewController(animated: true)
        }, index: index)
        navigationController?.pushViewController(answerPromptViewController, animated: true)
    }

}
