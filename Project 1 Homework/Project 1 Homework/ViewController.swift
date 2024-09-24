//
//  ViewController.swift
//  Project 1 Homework
//
//  Created by Bruce on 2024/9/17.
//

import UIKit

class ViewController: UITableViewController {
    var imageNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "View Storm"
        
        let resourcePath = Bundle.main.resourcePath!
        imageNames = try! FileManager.default.contentsOfDirectory(atPath: resourcePath + "/Content")
        imageNames = imageNames.sorted(by: <)
        print(imageNames)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
    }
    
    @objc func shareApp() {
        let appURL = "https://apps.apple.com/us/app/apple-developer/id640199958"
        let vc: UIActivityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: [])
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = imageNames[indexPath.row]
        content.textProperties.font = UIFont.systemFont(ofSize: 22)
        cell.contentConfiguration = content
//        cell.textLabel?.text = imageNames[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.imageName = imageNames[indexPath.row]
            vc.title = "Picture \(indexPath.row + 1) of \(imageNames.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

