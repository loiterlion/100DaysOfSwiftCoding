//
//  DetailViewController.swift
//  GCD Closure Example
//
//  Created by Bruce on 2024/10/10.
//

import UIKit

class DetailViewController: UIViewController {
    let num = 99
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
        
        performSelector(inBackground: #selector(timeConsumingAction), with: nil)
        
//        DispatchQueue.global(qos: .default).async { [weak self] in
//            sleep(5)
//            if let num = self?.num {
//                print(num)
//            }
//        }
    }
    
    @objc func timeConsumingAction() {
        sleep(5)
        print(num)
    }
    
    deinit {
        print("deinited")
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
