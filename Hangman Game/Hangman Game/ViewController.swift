//
//  ViewController.swift
//  Hangman Game
//
//  Created by Bruce on 2024/10/11.
//

import UIKit

class ViewController: UIViewController {
    var quizLabel: UILabel!
    var quizWord = ""
    var allWords = [String]()
    var tapCount = 0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        let alphabets = Array("abcedfghijklmnopqrstuvwxyz")
        
        let quizLabel = UILabel()
        quizLabel.text = "Apple"
        quizLabel.textAlignment = .center
        quizLabel.font = .systemFont(ofSize: 20)
        quizLabel.translatesAutoresizingMaskIntoConstraints = false
        quizLabel.backgroundColor = .gray
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
        }
        
        NSLayoutConstraint.activate([
            quizLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            quizLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quizLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            quizLabel.heightAnchor.constraint(equalToConstant: 100),
            
            buttonsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            buttonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadLetters()
        }
    }

    fileprivate func nextWord() {
        DispatchQueue.main.async { [unowned self] in
            tapCount = 0
            quizWord = allWords.randomElement()!
            self.quizLabel.text = String(repeating: "?", count: self.quizWord.count)
        }
    }
    
    func loadLetters() {
        print("Loading letters from local file")
        guard let urlString = Bundle.main.url(forResource: "quiz", withExtension: "txt") else { return }
        guard let content = try? String(contentsOf: urlString) else { return }
        allWords = content.components(separatedBy: "\n")
        
        nextWord()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let labelText = quizLabel.text else { return }
        guard let letter = sender.titleLabel?.text else { return }
        
        print(letter + " is tapped")
        
        let lettersInWord = Array(quizWord)
        var lettersInLabel = Array(labelText)
        
        if !quizWord.contains(letter) {
            tapCount += 1
        }
        if tapCount == 7 {
            let ac = UIAlertController(title: "Fail", message: "You're tried 7 times.\n Correct word is \(quizWord)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try next?", style: .default, handler: { [weak self]_ in
                self?.nextWord()
            }))
            present(ac, animated: true)
        }
        
        
        for (index, ch) in lettersInWord.enumerated() {
            if String(ch) == letter {
                lettersInLabel[index] = ch
            }
        }
        
        let joinedString = String(lettersInLabel)
        quizLabel.text = joinedString
        if quizLabel.text == quizWord {
            let ac = UIAlertController(title: "Congrats", message: "correct", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try next?", style: .default, handler: { [weak self]_ in
                self?.nextWord()
            }))
            present(ac, animated: true)
        }
        
        
    }
}

