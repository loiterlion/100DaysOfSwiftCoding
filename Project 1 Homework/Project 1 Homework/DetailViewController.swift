//
//  DetailViewController.swift
//  Project 1 Homework
//
//  Created by Bruce on 2024/9/17.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var imageName: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = imageName {
            imageView.image = UIImage(named: imageToLoad)
        }
        
        assert(imageView != nil, "no image error")
        
        navigationItem.largeTitleDisplayMode = .never
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(barButtonTapped))
    }
    
    @objc func barButtonTapped() {
        guard let image = imageView.image else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: ["A Very Beautifule Image", "another string", "and another string", image], applicationActivities: [])
        self.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
