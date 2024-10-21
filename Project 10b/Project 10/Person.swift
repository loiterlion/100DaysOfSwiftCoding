//
//  Person.swift
//  Project 10
//
//  Created by Bruce on 2024/10/15.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
