//
//  ViewController.swift
//  Project 27 Core Graphics
//
//  Created by Bruce on 2025/2/27.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 6 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawLines()
        case 1:
            drawEclipse()
        case 2:
            drawCheckboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawRectangle()
        case 5:
            drawImagesAndText()
        case 6:
            drawSmilingFaceEmoji()
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawEclipse() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2)  {
                        let rect = CGRect(x: col * 64, y: row * 64, width: 64, height: 64)
                        ctx.cgContext.addRect(rect)
                        ctx.cgContext.drawPath(using: .fill)
                    }
                }
            }
            
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
            
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 10
            let amount = Double.pi / Double(rotations)
            for _ in 0..<rotations {
                ctx.cgContext.rotate(by: amount)
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
                
            }
            ctx.cgContext.strokePath()
            
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            var length = 200.0
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
            ctx.cgContext.move(to: CGPoint(x: length, y: 50))

            for _ in 0 ..< 40 {
                ctx.cgContext.rotate(by: .pi / Double(2))
                ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                length *= 0.95
            }
            
            ctx.cgContext.drawPath(using: .stroke)
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
           let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gan aftagley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
            
        }
        
        imageView.image = image
    }
    
    func drawSmilingFaceEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            let bgRect = CGRect(x: 0, y: 0, width: 100, height: 100)
            let rect = bgRect.insetBy(dx: 2, dy: 2)
            
            // Step 1: Get the current graphics context
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            
            let bgPath = UIBezierPath(ovalIn: bgRect)
            
            context.addPath(bgPath.cgPath)
            context.setFillColor(UIColor.orange.cgColor)
            context.drawPath(using: .fill)
            
            // Step 2: Create a circular path
            let circlePath = UIBezierPath(ovalIn: rect)
            
            // Step 3: Define the gradient colors (yellow to orange)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors: [CGColor] = [UIColor.yellow.cgColor, UIColor.orange.cgColor]
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0.0, 1.0])
            
            // Step 4: Clip the context to the circular path
            context.saveGState()
            context.addPath(circlePath.cgPath)
            context.clip()  // Clip to the circle shape
            
            // Step 5: Draw the gradient (from top-left to bottom-right)
            var startPoint = CGPoint(x: rect.origin.x, y: rect.origin.y)
            var endPoint = CGPoint(x: rect.size.width, y: rect.size.height)
            context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
            
            context.restoreGState()
            
            // Draw two eyes
            context.addEllipse(in: CGRect(x: 33 - 5, y: 30, width: 10, height: 20))
            context.addEllipse(in: CGRect(x: 66 - 5, y: 30, width: 10, height: 20))
            context.setFillColor(UIColor.brown.cgColor)
            context.drawPath(using: .fill)
            
            

            
            let pointA = CGPoint(x: 33, y: 66)
            let pointB = CGPoint(x: 66, y: 66)
            
            let controlPoint1 = CGPoint(x: 40, y: 70)
            let controlPoint2 = CGPoint(x: 60, y: 70)
            
            
            let controlPoint3 = CGPoint(x: 60, y: 80)
            let controlPoint4 = CGPoint(x: 40, y: 80)
            
            let bezierPath1 = UIBezierPath()
            bezierPath1.move(to: pointA)
            bezierPath1.addCurve(to: pointB, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            
            bezierPath1.move(to: pointB)
            bezierPath1.addCurve(to: pointA, controlPoint1: controlPoint3, controlPoint2: controlPoint4)
                        
            UIColor.red.setFill()
            bezierPath1.fill()
            
            UIColor.black.setStroke()
            bezierPath1.lineWidth = 2
            bezierPath1.stroke()
                        
        }
        
        imageView.image = image
    }
}

