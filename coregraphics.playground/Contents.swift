import UIKit
import CoreGraphics

var greeting = "Hello, playground"


let bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
let renderer = UIGraphicsImageRenderer(size: bounds.size)
let image = renderer.image { context in
    // Call draw() to render the shapes in the current context
    // 1. Draw a rectangle with a color
    let rectanglePath = UIBezierPath(rect: CGRect(x: 50, y: 50, width: 200, height: 100))
    UIColor.red.setFill()  // Set the color to red
    rectanglePath.fill()   // Fill the rectangle with the red color
    
    // 2. Draw a circle with a different color
    let circlePath = UIBezierPath(ovalIn: CGRect(x: 100, y: 200, width: 150, height: 150))
    UIColor.blue.setFill()  // Set the color to blue
    circlePath.fill()       // Fill the circle with the blue color
}

let imageView = UIImageView(frame: bounds)
imageView.image = image
