//
//  ViewController.swift
//  Day23Challenge
//
//  Created by Bruce on 2024/9/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Day23Challenge"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadCountries()
    }

    func loadCountries() {
        let fm = FileManager.default
        let resourcePath = Bundle.main.resourcePath!
        let files = try! fm.contentsOfDirectory(atPath: resourcePath)
        for item in files {
            if item.hasSuffix("png") {
                countries.append(item)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = countries[indexPath.row]
        config.image = UIImage(named: countries[indexPath.row])
        cell.contentConfiguration = config
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.image = UIImage(named: countries[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

