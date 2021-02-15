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
    
    var testUserData: InstagramTestUser?
    var mainVC: SocialMediaViewController?
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        InstagramAPI.shared.authorizeApplication { (url) in
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url!))
            }
        }
    }
    
    func dismissViewController() {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.mainVC?.testUserData = self.testUserData!
            }
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        InstagramAPI.shared.getTestUserIDAndToken(request: request) { [weak self] (instagramTestUser) in
            guard let self = self else { return }
            self.testUserData = instagramTestUser
            self.dismissViewController()
        }
        decisionHandler(.allow)
    }
    
}
