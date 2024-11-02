//
//  ViewController.swift
//  Project 1 Homework
//
//  Created by Bruce on 2024/9/17.
//

import UIKit

class ViewController: UITableViewController {
    var imageNames = [String]()

    fileprivate func loadPhotos() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            let resourcePath = Bundle.main.resourcePath!
            self.imageNames = try! FileManager.default.contentsOfDirectory(atPath: resourcePath + "/Content")
            self.imageNames = self.imageNames.sorted(by: <)
            
            DispatchQueue.main.async { [weak self] in
                print("tableView reload data")
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "View Storm"
        
        loadPhotos()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        print("view did load")
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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Bad") as? DetailViewController {
            vc.imageName = imageNames[indexPath.row]
            vc.title = "Picture \(indexPath.row + 1) of \(imageNames.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

