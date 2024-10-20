//
//  ViewController.swift
//  Project 12
//
//  Created by Bruce on 2024/10/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        defaults.set("Steve", forKey: "name")
        defaults.set(60, forKey: "age")
        defaults.set(CGFloat.pi, forKey: "Pi")
        defaults.set(Date(),forKey: "LastRun")
        
        let array = ["apple", "banana"]
        defaults.set(array,forKey: "fruits")
        
        let dic = ["name": "Steve", "country": "UK"]
        defaults.set(dic,forKey: "savedDictionary")
        
        let name = defaults.value(forKey: "name") as? String ?? "null"
        
        let savedDict = defaults.dictionary(forKey: "savedDictionary") ?? [String: String]()
        
        let savedDic2 = defaults.object(forKey: "savedDictionary") ?? [String: String]()
        
        print(name)
        print(savedDic2)
        
    }


}

