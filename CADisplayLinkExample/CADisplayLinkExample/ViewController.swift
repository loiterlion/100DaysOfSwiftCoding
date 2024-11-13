//
//  ViewController.swift
//  CADisplayLinkExample
//
//  Created by Bruce on 2024/11/11.
//

import UIKit

class ViewController: UIViewController {

    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let displayLink = CADisplayLink(target: self, selector: #selector(action))
        displayLink.add(to: RunLoop.current, forMode: .common)
        
    }
    
    
    @objc func action() {
        count += 1
        if count % 60 == 0 {
            print("\(count)")
        }
    }


}

