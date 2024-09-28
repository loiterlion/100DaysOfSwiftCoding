//
//  ViewController.swift
//  Project5
//
//  Created by Bruce on 2024/9/26.
//

import UIKit

class ViewController: UITableViewController {
    var allWords: [String] = [String]()
    var usedWords: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = Bundle.main.url(forResource: "start", withExtension: "txt")
        guard let url = url else { return }
        
        allWords = ["nothing"]
        
        if let content = try? String(contentsOf: url) {
            allWords = content.components(separatedBy: "\n")
        }
        
        startGame()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Input a word", message: nil, preferredStyle: .alert)
        ac.addTextField { UITextField in
            // TODO
        }
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self, weak ac] _ in
            if let text = ac?.textFields?[0].text {
                self?.submit(text)
            }
        }))
        
        present(ac, animated: true)
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = usedWords[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
    
    fileprivate func showError(_ errorTitle: String, _ errorMsg: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowercased = answer.lowercased()
        
        if answer.count < 3 {
            showError("Too Short", "Less Than 3 words!")
            return
        }
        
        if answer == title {
            showError("Same as the title", "It's now allowed")
            return
        }
        
        if !isPossible(lowercased) {
            showError("Not possible!", "You can't spell the that from the word \(lowercased)")
            return
        }
        
        if !isOriginal(lowercased) {
            showError("Word used already", "Be more original!")
            return
        }
        
        if !isReal(lowercased) {
            showError("Word not recognised", "You can't just make them up, you know!")
            return
        }
        
        usedWords.insert(lowercased, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }

    func isPossible(_ word: String) -> Bool {
        guard var tmp = title?.lowercased() else { return false}
        
        for letter in word {
            if let index = tmp.firstIndex(of: letter) {
                tmp.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }

    func isOriginal(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(_ word: String) -> Bool {
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
}

