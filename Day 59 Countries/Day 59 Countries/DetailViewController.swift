//
//  DetailViewController.swift
//  Day 59 Countries
//
//  Created by Bruce on 2024/10/31.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var country: Country!
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareActivity))
        // Do any additional setup after loading the view.
        loadCountryHTML()
    }
    
    @objc func shareActivity() {
           // Content to share
        let textToShare = "Check this: \(country.description())"
           
           // Create an array with items you want to share
        let itemsToShare: [Any] = [textToShare]
           
           // Initialize the UIActivityViewController with the items to share
           let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
           
           // For iPads, specify where the popover should appear
           activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
           
           // Present the activity view controller
           present(activityViewController, animated: true, completion: nil)
       }
    
    func loadCountryHTML() {
            // Create a styled HTML string with string interpolation
            let timezonesHTML = country.timezones.map { "<li>\($0)</li>" }.joined()
            let htmlString = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
                <style>
                    body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; margin: 0; padding: 20px; background-color: #f9f9f9; color: #333; }
                    .country-container { text-align: center; max-width: 100%; margin: auto; padding: 15px; background-color: #fff; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); border-radius: 8px; }
                    h1 { font-size: 1.8em; margin: 10px 0; color: #007AFF; }
                    .emoji { font-size: 2.5em; margin: 10px 0; }
                    .info { font-size: 1em; color: #666; margin-bottom: 15px; }
                    .timezone-list { text-align: left; padding: 0; list-style: none; }
                    .timezone-list li { padding: 5px 0; font-size: 0.95em; }
                </style>
            </head>
            <body>
                <div class="country-container">
                    <h1>\(country.name)</h1>
                    <div class="emoji">\(country.emoji)</div>
                    <p class="info">Unicode: \(country.unicode) | Region: \(country.region)</p>
                    <h2>Timezones</h2>
                    <ul class="timezone-list">
                        \(timezonesHTML)
                    </ul>
                </div>
            </body>
            </html>
            """
            
            // Load the HTML into the WKWebView
            webView.loadHTMLString(htmlString, baseURL: nil)
        }

}
