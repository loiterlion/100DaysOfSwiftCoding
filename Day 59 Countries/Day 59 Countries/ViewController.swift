//
//  ViewController.swift
//  Day 59 Countries
//
//  Created by Bruce on 2024/10/31.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Countries Wiki"
        loadData()
        print("view did load")
    }

    func loadData() {
        DispatchQueue.global().async { [unowned self] in
            
//            let string = "https://github.com/Khodour/countries.json/blob/main/countries.json"
//            guard let url = URL(string: string) else { return }
//
//            do {
//                let data = try Data(contentsOf: url)
//            } catch {
//                print(error)
//            }
            sleep(2)
            guard let url = Bundle.main.url(forResource: "countriesJSON", withExtension: "json") else { return }
            
            guard let data = try? Data(contentsOf: url) else { return }
            
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Country].self, from: data) {
                countries = decoded
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = countries[indexPath.row].name
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        
        vc.country = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

