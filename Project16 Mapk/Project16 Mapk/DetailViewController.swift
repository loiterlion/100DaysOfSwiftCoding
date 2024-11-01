//
//  DetailViewController.swift
//  Project16 Mapk
//
//  Created by Bruce on 2024/11/1.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var url: URL?
    
    override func loadView() {
        super.loadView()
        let webview = WKWebView()
        if let url = url {
            webview.load(URLRequest(url: url))
        }
        view = webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
