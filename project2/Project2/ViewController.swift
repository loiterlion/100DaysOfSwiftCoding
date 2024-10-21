//
//  ViewController.swift
//  Project2
//
//  Created by TwoStraws on 13/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var button1: UIButton!
	@IBOutlet var button2: UIButton!
	@IBOutlet var button3: UIButton!

	var countries = [String]()
	var correctAnswer = 0
    var score = 0
    var currentQuestion = 0
    var highestScore = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		button1.layer.borderWidth = 1
		button2.layer.borderWidth = 1
		button3.layer.borderWidth = 1

		button1.layer.borderColor = UIColor.lightGray.cgColor
		button2.layer.borderColor = UIColor.lightGray.cgColor
		button3.layer.borderColor = UIColor.lightGray.cgColor
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showCurrentScore))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showCurrentScore))

		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        if let savedData = UserDefaults.standard.value(forKey: "highestScore") as? Int {
            highestScore = savedData
        }
        
		askQuestion()
        
	}
    
    @objc func showCurrentScore() {
        let ac = UIAlertController(title: "Curren Score", message: "Your current score: \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "I got it", style: .default))
        present(ac, animated: true)
    }

    fileprivate func resetGame() {
        currentQuestion = 0
        score = 0
        correctAnswer = 0
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
		countries.shuffle()

		button1.setImage(UIImage(named: countries[0]), for: .normal)
		button2.setImage(UIImage(named: countries[1]), for: .normal)
		button3.setImage(UIImage(named: countries[2]), for: .normal)

        correctAnswer = Int.random(in: 0...2)
		title = countries[correctAnswer].uppercased() + ", score:\(score), Highest: \(highestScore)"
        
	}

	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String

        var msg = ""
		if sender.tag == correctAnswer {
			title = "Correct"
			score += 1
            msg = "Correct!"
		} else {
			title = "Wrong"
			score -= 1
            msg = "Wrong! That’s the flag of \(countries[sender.tag].uppercased()),"
		}
        
        currentQuestion += 1
        
        let ac = UIAlertController(title: title, message: msg + " Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: continueTapped))
        present(ac, animated: true)
	}

    func continueTapped(action: UIAlertAction! = nil) {
        if currentQuestion != 10 {
            askQuestion()
        } else {
            showFinalScore()
            resetGame()
        }
    }
    
    func showFinalScore() {
        // show final score
        if score > highestScore {
            let ac = UIAlertController(title: "New Record", message: "Final score: \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
            present(ac, animated: true)
            highestScore = score
            UserDefaults.standard.setValue(highestScore, forKey: "highestScore")
        } else {
            let ac = UIAlertController(title: "Final Score", message: "Your final score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
        }
    }
}
