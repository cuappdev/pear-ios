//
//  HomeViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import GoogleSignIn
import UIKit

class HomeViewController: UIViewController {

    private let logoutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
        view.addSubview(logoutButton)

        setupConstraints()
    }

    private func setupConstraints() {
        logoutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc private func logoutPressed() {
        GIDSignIn.sharedInstance().signOut()
    
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }

}
