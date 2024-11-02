//
//  ViewController.swift
//  Project 18
//
//  Created by Bruce on 2024/11/2.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(1, 2, 3, 4, 5)
        print(1, 2, 3, 4, 5, separator: "_")
        print(1, 2, 3, 4, 5, separator: "_", terminator: "")
        
        // assert works only in debug mode
        assert(1 == 1, "Math error")
        
        
        for i in 0..<100 {
            print(i)
        }
        
        
        let animal: Animal = Animal()
        
        var dog = animal as? Dog
        print(dog)
    }
    
    
    class Animal {}

    class Dog: Animal {}



}

