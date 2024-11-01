//
//  Capital.swift
//  Project16 Mapk
//
//  Created by Bruce on 2024/10/31.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var info: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
