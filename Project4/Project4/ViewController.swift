//
//  ViewController.swift
//  Project4
//
//  Created by Bruce on 2024/9/24.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var websites = ["apple.com", "hackingwithswift.com"]
    
    var handler: ((WKNavigationActionPolicy) -> Void)!
    
    override func loadView() {
        super.loadView()
        
        webView = WKWebView()
        view = webView
        
        webView.navigationDelegate = self
        let url = URL(string: "https://www.baidu.com")!
        let request = URLRequest(url: url)
        
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        navigationController?.isToolbarHidden = false
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        toolbarItems = [
            UIBarButtonItem(customView: progressView),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        ]
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            guard let newValue = change?[.newKey] as? Double else { return }
            progressView?.progress = Float(newValue)
        }
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: alertHandler))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func alertHandler(sender: UIAlertAction) {
        guard let title = sender.title else { return }
        guard let url = URL(string: "https://" + title) else { return }
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Use escaping closure
        handler = decisionHandler
        
        let ac = UIAlertController(title: "Continue?", message: navigationAction.request.url?.host, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.handler(.allow)
        }))
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            self.handler(.cancel)
        }))
        present(ac, animated: true, completion: nil)
        
    }
}

