//
//  ViewController.swift
//  Project7
//
//  Created by Bruce on 2024/10/1.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filterdPetitions = [Petition]()
    var isFiltered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        addCreditBBI()
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    fileprivate func addCreditBBI() {
        
        let filterBBI = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBBITapped))
        let creditBBI = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(creditBBITapped))
        navigationItem.rightBarButtonItems = [
            filterBBI,
            creditBBI
        ]
    }
    
    @objc func searchBBITapped() {
        if isFiltered {
            isFiltered = false
            filterdPetitions = petitions
            tableView.reloadData()
            return
        }

        let ac = UIAlertController(title: "filter", message: "Input filter words", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
            guard let text = ac.textFields?[0].text else { return }
            
            filterdPetitions.removeAll(keepingCapacity: true)
            filterdPetitions = petitions.filter { petition in
                if let flag1 = petition.title?.contains(text) {
                    if flag1 { return true }
                }
                
                if let flag2 = petition.body?.contains(text) {
                    if flag2  { return true }
                }
                
                return false
            }
            
            isFiltered = true
            tableView.reloadData()
        }))
        
        present(ac, animated: true)
    }
    
    @objc func creditBBITapped() {
        let ac = UIAlertController(title: "Credit", message: "The data is from We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Error", message: "Error loading data", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsongPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsongPetitions.results
            filterdPetitions = petitions
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Petition", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let petition = filterdPetitions[indexPath.row]
        content.text = petition.title
        content.secondaryText = petition.body
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filterdPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

