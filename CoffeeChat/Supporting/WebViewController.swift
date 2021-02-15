//
//  WebViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/14/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//
//

import Foundation
import WebKit

class WebViewController: UIViewController {
    
    var mainViewController: SocialMediaViewController
    private let webView = WKWebView()
    
    init(mainViewController: SocialMediaViewController) {
        self.mainViewController = mainViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        authorizeApplication()
    }
    
    private func authorizeApplication() {
        InstagramAPI.shared.authorizeApplication { url in
            DispatchQueue.main.async {
                guard let url = url else { return }
                self.webView.load(URLRequest(url: url))
            }
        }
    }
    
    func dismissViewController(userData: InstagramAuthentication) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.mainViewController.testUserData = userData
            }
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        InstagramAPI.shared.getTestUserIDAndToken(request: navigationAction.request) { [weak self] instagramTestUser in
            guard let self = self else { return }
            self.dismissViewController(userData: instagramTestUser)
        }
        decisionHandler(.allow)
    }
    
}
