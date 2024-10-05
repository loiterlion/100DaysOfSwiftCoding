//
//  ViewController.swift
//  Day32 Shopping List
//
//  Created by Bruce on 2024/9/30.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Shopping List"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearTapped))
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showPrompt))
        ]
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = shoppingList[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
    
    @objc func clearTapped() {
        shoppingList.removeAll(keepingCapacity: true)
        if let indexPaths = tableView.indexPathsForVisibleRows {
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        
    }
    
    @objc func shareTapped() {
        if shoppingList.isEmpty {
            return
        }
        
        let content = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    
    @objc func showPrompt() {
        let ac = UIAlertController(title: "Add to list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let text = ac.textFields?[0].text {
                self.shoppingList.insert(text, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }))
        present(ac, animated: true, completion: nil)
    }
}

