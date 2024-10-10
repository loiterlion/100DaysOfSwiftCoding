//
//  Petitions.swift
//  Project7
//
//  Created by Bruce on 2024/10/1.
//

import Foundation

class Petition: Codable {
    var title: String?
    var body: String?
}

class Petitions: Codable {
    var results: [Petition]
}
