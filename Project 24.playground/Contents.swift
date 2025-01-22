import UIKit
import Darwin

var greeting = "Hello, swift"


for letter in greeting {
    print("letter is \(letter)")
}

extension String {
    subscript(i: Int) -> String {
        String(self[index(startIndex, offsetBy: i)])
    }
}

let languages = ["python", "swift", "ruby"]
languages.contains(where: greeting.contains)

var atrributedString = NSMutableAttributedString(string: greeting)
atrributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: 2))
atrributedString.addAttribute(.strikethroughColor, value: UIColor.yellow, range: NSRange(location: 0, length: 3))


extension String {
    func withPrefix(prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        }
        
        return prefix + self
    }
    
    func isNumeric() -> Bool {
        Double(self) != nil
    }
    
    var lines: [String] {
        self.components(separatedBy: "\n")
    }
}


print("abc".withPrefix(prefix: "Hello"))
print("ghher12asdflkj3".isNumeric())

print("abc\ndef\nghi".lines)

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            let size = self.frame.size
            
            let t = 0.0001
            let newFrame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: size.width * t, height: size.height * t)
            self.frame = newFrame
        }
    }
}
