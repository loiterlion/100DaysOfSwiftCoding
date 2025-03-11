//
//  ViewController.swift
//  Day 90 Milestone Meme Generation
//
//  Created by Bruce on 2025/3/10.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var firstLine = ""
    var secondLine = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func start(_ sender: Any) {
        // Prompt the user to import a photo from their photo library
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        
        picker.dismiss(animated: true) { [self] in
            self.imageView.image = image
            addFirstLine()
        }
    }
    @IBAction func addFirstLine() {
        let ac = UIAlertController(title: "Add first line of text", message: "", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { alertAction in
            if let tf = ac.textFields?.first {
                self.firstLine = tf.text ?? ""
            }
            self.addSecondLine()
        }))
        present(ac, animated: true) 
    }
    
    func addSecondLine() {
        let ac = UIAlertController(title: "Add Second line of text", message: "", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { alertAction in
            if let tf = ac.textFields?.first {
                self.secondLine = tf.text ?? ""
            }
            
            self.produceMeme()
        }))
        present(ac, animated: true)
    }
    
    func produceMeme() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
        
        let image = renderer.image { ctx in
            let img = imageView.image
            img?.draw(in: imageView.bounds)
//            img?.draw(at: CGPoint(x: 0, y: 0))

            
            let attrs1: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 25),
                .foregroundColor: UIColor.red,
            ]
            
            let attrs2: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 25),
                .foregroundColor: UIColor.yellow,
            ]
            
            let attributedString1 = NSAttributedString(string: firstLine, attributes: attrs1)
            attributedString1.draw(with: CGRect(x: 0, y:100, width: 300, height: 100), options: .usesLineFragmentOrigin, context: nil)
            
            let attributedString2 = NSAttributedString(string: secondLine, attributes: attrs2)
            attributedString2.draw(with: CGRect(x: 0, y: 200, width: 300, height: 100), options: .usesLineFragmentOrigin, context: nil)
        }
        
        DispatchQueue.main.async {
            self.imageView.image = image
            
            // Share the image with friend
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            self.present(vc, animated: true)
        }
    }
}

