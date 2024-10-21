//
//  ViewController.swift
//  Project 1 Homework
//
//  Created by Bruce on 2024/9/17.
//

import UIKit

class ViewController: UITableViewController {
    var imageNames = [String]()
    var shownCount: [Int]!

    fileprivate func loadPhotos() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            let resourcePath = Bundle.main.resourcePath!
            self.imageNames = try! FileManager.default.contentsOfDirectory(atPath: resourcePath + "/Content")
            self.imageNames = self.imageNames.sorted(by: <)
            
            if let savedData = UserDefaults.standard.object(forKey: "shownCount") as? [Int] {
                self.shownCount = savedData
            } else {
                self.shownCount = Array(repeating: 0, count: self.imageNames.count)
            }
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        
        content.secondaryText = "Shown count: \(shownCount[indexPath.row])"
        
        cell.contentConfiguration = content
//        cell.textLabel?.text = imageNames[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.imageName = imageNames[indexPath.row]
            vc.title = "Picture \(indexPath.row + 1) of \(imageNames.count)"
            
            shownCount[indexPath.row] += 1
            
            let defaults = UserDefaults.standard
            defaults.set(shownCount, forKey: "shownCount")
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

