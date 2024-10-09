//
//  ViewController.swift
//  Project 8
//
//  Created by Bruce on 2024/10/6.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var usedButtons = [UIButton]()
    
    var isLevelCompleted: Bool  {
        usedButtons.count == 20
    }
    
    var solutions = [String]()
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.textAlignment = .left
        cluesLabel.text = "CLUES"
//        cluesLabel.backgroundColor = .red
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "Answer"
        answersLabel.numberOfLines = 0
//        answersLabel.backgroundColor = .blue
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .right
        currentAnswer.font = UIFont.systemFont(ofSize: 48)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)

        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                let button = UIButton(type: .system)
                button.frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                button.setTitle("AAA", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                button.addTarget(self, action: #selector(lettersTapped), for: .touchUpInside)
                button.layer.borderColor = UIColor.gray.cgColor
                button.layer.borderWidth = 1
                buttonsView.addSubview(button)
                
                letterButtons.append(button)
            }
        }

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: cluesLabel.topAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),

            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        scoreLabel.backgroundColor = .cyan
//        buttonsView.backgroundColor = .yellow
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }

    @objc func lettersTapped(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        
        currentAnswer.text?.append(buttonText)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answer = currentAnswer.text else { return }
        
        if let index = solutions.firstIndex(of: answer) {
            usedButtons.append(contentsOf: activatedButtons)
            activatedButtons.removeAll()
            
            score += 1
            
            currentAnswer.text = ""
            
            var splittedAnswers = answersLabel.text?.components(separatedBy: "\n")
            splittedAnswers![index] = answer
            answersLabel.text = splittedAnswers?.joined(separator: "\n")
            
            if isLevelCompleted {
                
                let ac = UIAlertController(title: "Level Completed!!!", message: "Try next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nextLevel))
                
                present(ac, animated: true)
            }
        } else {
            score -= 1
            
            let ac = UIAlertController(title: "Oops", message: "Try again:)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {[unowned self] _ in
                for button in activatedButtons {
                    button.isHidden = false
                }
                activatedButtons.removeAll()
                currentAnswer.text = ""
            }))
            present(ac, animated: true)
        }
    }
    
    func nextLevel(sender: UIAlertAction) {
        level += 1
        
        usedButtons.removeAll(keepingCapacity: true)
        
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    func loadLevel() {
        guard let urlString = Bundle.main.path(forResource: "level\(level)", ofType: "txt") else { return }
        if let content = try? String(contentsOfFile: urlString) {
            var lines = content.components(separatedBy: "\n")
            lines.shuffle()
            
            var clues = [String]()
            var wordCountString = [String]()
            var wordBits = [String]()
            
            for (index, line) in lines.enumerated() {
                print("\(index)" + "\(line)")
                let parts = line.components(separatedBy: ": ")
                
                let wordBit = parts[0].components(separatedBy: "|")
                wordBits += wordBit
                
                let answer = parts[0].replacingOccurrences(of: "|", with: "")
                
                solutions.append(answer)
                
                clues.append("\(index + 1) \(parts[1])")
                wordCountString.append("\(answer.count) letters")
            }
            
            cluesLabel.text = clues.joined(separator: "\n")
            answersLabel.text = wordCountString.joined(separator: "\n")
            wordBits.shuffle()
            
            for (index, item) in letterButtons.enumerated() {
                item.setTitle(wordBits[index], for: .normal)
            }
        }
        
    }
}

