//
//  ViewController.swift
//  Project 15 Animation
//
//  Created by Bruce on 2024/10/29.
//

import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    var currentAnimation = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = self.view.center
        self.view.addSubview(imageView)
        self.imageView = imageView
    }

    @IBAction func tapped(_ sender: UIButton) {
        
        
        sender.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            case 1:
                self.imageView.transform = CGAffineTransform.identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            case 3:
                self.imageView.transform = CGAffineTransform.identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = CGAffineTransform.identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        } completion: { finished in
            sender.isHidden = false
        }

        
//        UIView.animate(withDuration: 1, delay: 0, options: []) {
//            switch self.currentAnimation {
//            case 0:
//                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
//            case 1:
//                self.imageView.transform = CGAffineTransform.identity
//            case 2:
//                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
//            case 3:
//                self.imageView.transform = CGAffineTransform.identity
//            case 4:
//                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
//            case 5:
//                self.imageView.transform = CGAffineTransform.identity
//            case 6:
//                self.imageView.alpha = 0.1
//                self.imageView.backgroundColor = .green
//            case 7:
//                self.imageView.alpha = 1
//                self.imageView.backgroundColor = .clear
//            default:
//                break
//            }
//        } completion: { finished in
//            sender.isHidden = false
//        }

        currentAnimation += 1
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
}

