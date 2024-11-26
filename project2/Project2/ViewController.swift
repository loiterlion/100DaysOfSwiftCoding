//
//  ViewController.swift
//  Project2
//
//  Created by TwoStraws on 13/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import NotificationCenter
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
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
        
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [unowned self] _ in
            registerLocalNotification()
            scheduleLocalNotificationWith(timeInterval: 0)
//        }
        

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
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func registerLocalNotification() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if granted {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Yes, notification allowed", message: "You can received notif")
                }
                
            } else {
                DispatchQueue.main.async {
                    self?.showAlert(title: "No, notification disallowed", message: "You can set up notification in the system setting")
                }
            }
        }
    }
    
    func scheduleLocalNotificationWith(timeInterval: TimeInterval) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        

        
        for i in [7, 30, 60] {
            let content = UNMutableNotificationContent()
            content.title = "Come to play \(i)"
            content.body = "You'll get better at guessing the flags!"
            content.categoryIdentifier = "guessFlags"
            content.userInfo = ["customData": "information"]
//            var dateComponents = DateComponents()
//            dateComponents.second = i
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i), repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "play", title: "play Guss the flag game", options: .foreground)
        let category = UNNotificationCategory(identifier: "guessFlags", actions: [show], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("customData: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier, "play":
                print("You finally come here")
                showAlert(title: "You finally come here", message: "")
                scheduleLocalNotificationWith(timeInterval: 0)
            default:
                break
            }
            
            completionHandler()
        }
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
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { [unowned self] finished in
            let ac = UIAlertController(title: title, message: msg + " Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { ac in
                if currentQuestion != 10 {
                    askQuestion()
                } else {
                    showFinalScore()
                    resetGame()
                }
                sender.transform = CGAffineTransform.identity
            }))
            present(ac, animated: true)
        }
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
