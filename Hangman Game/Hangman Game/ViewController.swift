//
//  ViewController.swift
//  Hangman Game
//
//  Created by Bruce on 2024/10/11.
//

import UIKit

class ViewController: UIViewController {
    var quizLabel: UILabel!
    var allKeyButtons = [UIButton]()
    
    
    var quizWord = ""
    var wordToShow = ""
    var usedLetters = [String]()
    var allWords = [String]()
    var trialTimeLeft = 7
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        let alphabets = Array("abcedfghijklmnopqrstuvwxyz")
        
        let quizLabel = UILabel()
        quizLabel.text = ""
        quizLabel.textAlignment = .center
        quizLabel.font = .systemFont(ofSize: 40)
        quizLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(quizLabel)
        self.quizLabel = quizLabel
        
        
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        let width = 28
        let height = 20
        for i in 0..<26 {
            let button = UIButton(type: .system)

            button.setTitle(String(alphabets[i]), for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.frame = CGRect(x: (i % 10) * (width + 2), y: (i / 10) * (height + 2), width: width, height: height)
            button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            buttonsView.addSubview(button)
            allKeyButtons.append(button)
        }
        
        NSLayoutConstraint.activate([
            quizLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            quizLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quizLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            quizLabel.heightAnchor.constraint(equalToConstant: 100),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5),
//            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLetters {
            DispatchQueue.main.async { [weak self] in
                self?.startGame()
            }
        }
    }

    fileprivate func nextWord() {
        DispatchQueue.main.async { [unowned self] in
            trialTimeLeft = 7
            quizWord = allWords.randomElement()!
            self.quizLabel.text = String(repeating: "?", count: self.quizWord.count)
        }
    }
    
    
    func startGame() {
        // reset data
        quizWord = allWords.randomElement()!
        trialTimeLeft = 7
        wordToShow = ""
        usedLetters.removeAll()
        
        
        // update UI
        quizLabel.text = String(repeating: "_", count: quizWord.count)
        for button in allKeyButtons {
            button.isEnabled = true
        }
        title = "Trail time left: \(trialTimeLeft)"
    }
    
    func loadLetters(handler: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in

            print("Loading letters from local file")
            guard let urlString = Bundle.main.url(forResource: "quiz", withExtension: "txt") else { return }
            guard let content = try? String(contentsOf: urlString) else { return }
            allWords = content.components(separatedBy: "\n")
            
            handler()
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        // if letter is contained in the Word
        guard let letter = sender.titleLabel?.text else { return }
        
        if quizWord.contains(letter) {
            usedLetters.append(letter)
        } else {
            // wrong letter
            trialTimeLeft -= 1
        }
        
        // update word to show
        var tmpWord = ""
        for letter in quizWord {
            if usedLetters.contains(String(letter)) {
                tmpWord.append(letter)
            } else {
                tmpWord.append("_")
            }
        }
        wordToShow = tmpWord
        sender.isEnabled = false
        
        // update UI
        updateUI()

        // check win or lose and show
        checkGameStatus()
    }
    
    func updateUI() {
        quizLabel.text = wordToShow
        title = "Trail time left \(trialTimeLeft)"
    }
    
    func checkGameStatus() {
        if trialTimeLeft == 0 {
            showGameResult(won: false)
        } else if quizWord == wordToShow {
            // show succeed alert
            showGameResult(won: true)
        }
    }
    
    func showGameResult(won: Bool) {
        let ac = UIAlertController(title: won ? "Win" : "Lose",
                                   message: won ? "Congrats" : "You lose, quizWord : [\(quizWord)]",
                                   preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Try next", style: .default, handler: { [weak self] _ in self?.startGame()
        }))
        present(ac,animated: true)
    }
}

