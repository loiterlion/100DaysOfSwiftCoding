//
//  Country.swift
//  Day 59 Countries
//
//  Created by Bruce on 2024/10/31.
//

import Foundation

struct Country: Codable {
    let name: String
    let unicode: String
    let emoji: String
    let region: String
    let timezones: [String]
    
    func description() -> String {
            // Joining the timezones array into a single string with commas
            let timezonesString = timezones.joined(separator: ", ")
            
            // Creating a formatted string
            return """
            Country: \(name)
            Emoji: \(emoji)
            Unicode: \(unicode)
            Region: \(region)
            Timezones: \(timezonesString)
            """
        }
}
