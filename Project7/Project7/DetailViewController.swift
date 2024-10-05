//
//  DetailViewController.swift
//  Project7
//
//  Created by Bruce on 2024/10/3.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupContent()
    }
    
    func setupContent() {
        guard let detailItem = detailItem else {
            return
        }

        let webString = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style> body {color: blue; font-size: 150%; background-color: #f0f0f0;}
            h1 {
                color: blue;
            }
            </style>
            </head>
            <body>
            \(detailItem.body ?? "empty")
            </body>
            </html>
            """
        webView.loadHTMLString(webString, baseURL: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
