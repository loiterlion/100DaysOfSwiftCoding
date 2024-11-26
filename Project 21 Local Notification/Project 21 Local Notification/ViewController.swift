//
//  ViewController.swift
//  Project 21 Local Notification
//
//  Created by Bruce on 2024/11/25.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted{
                print("Yes!")
            } else {
                print("NO!!!")
            }
        }
    }
    
    @objc func scheduleLocal() {
        scheduleLocalWith(timeInterval: 5)
    }

    func scheduleLocalWith(timeInterval: TimeInterval) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wakeup call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
//        content.sound = .default//UNNotificationSound(named: UNNotificationSoundName("notification-sound.wav"))
        
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show  = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        
        let showAfterOneDay  = UNNotificationAction(identifier: "showAfterOneDay", title: "Please show again a day after now", options: .foreground)

        let category = UNNotificationCategory(identifier: "alarm", actions: [show, showAfterOneDay], intentIdentifiers: [], options: [])
                
        center.setNotificationCategories([category])
    }
    
    func showAC(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("customData: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
                showAC(title: "Default identifer", message: "...")
            case "show":
                print("show more information")
                showAC(title: "Show more information", message: "Custom Data: \(customData)")
                
            case "showAfterOneDay":
                print("showAfterOneDay")
                scheduleLocalWith(timeInterval: 10)
            default:
                break
            }
        }

        completionHandler()
    }
}

