//
//  ViewController.swift
//  Day 82 Challenge
//
//  Created by Bruce on 2025/1/9.
//

import UIKit


extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
        }
        
    }
    
    func bounceOut1(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            let size = self.frame.size
            
            let t = 0.0001
            let newFrame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: size.width * t, height: size.height * t)
            self.frame = newFrame
        }
    }
}

extension Int {
    func times(action: () -> Void) {
        guard self > 0 else { return }
        
        for _ in 0..<self {
            action()
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        let index = self.firstIndex(of: item)
        guard let index = index else {
            return
        }
        self.remove(at: index)
    }
}


class ViewController: UIViewController {
    var animateView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let aView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        aView.backgroundColor = .blue
        self.view.addSubview(aView)
        
        animateView = aView
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animateView.bounceOut(duration: 1)
        
        let count = -3
        count.times {
            print("haha,")
        }
        
        var array = ["abc", "def", "abc"]
        
        array.remove(item: "abc")
        print(array)
    }
}

