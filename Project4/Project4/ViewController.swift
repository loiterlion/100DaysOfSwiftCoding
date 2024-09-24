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
    }


}

