//
//  DetailViewController.swift
//  Day 50 Milestone Challenge
//
//  Created by Bruce on 2024/10/21.
//

import UIKit

class DetailViewController: UIViewController {
    var imagePath: String!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let path = getDocumentaryFolder().appendingPathComponent(imagePath).path
        imageView.image = UIImage(contentsOfFile: path)
    }
    
    func getDocumentaryFolder() -> URL{
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
