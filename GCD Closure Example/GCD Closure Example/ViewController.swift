//
//  ViewController.swift
//  GCD Closure Example
//
//  Created by Bruce on 2024/10/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        // Do any additional setup after loading the view.
        let btn = UIButton(type: .system)
        btn.titleLabel?.text = "Tap me"
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        btn.frame = CGRect(x: 100, y: 100, width: 150, height: 100)
        view.addSubview(btn)
    }

    @objc func btnTapped() {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

