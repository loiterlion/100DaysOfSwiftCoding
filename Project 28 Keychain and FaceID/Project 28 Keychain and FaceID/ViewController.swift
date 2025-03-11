//
//  ViewController.swift
//  Project 28 Keychain and FaceID
//
//  Created by Bruce on 2025/3/7.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        print("This is:<\(#file)>:<\(#function)><\(#line)>" )
        super.viewDidLoad()
        
        title = "Nothing to see here"
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }


    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometrics are available
            // ... proceed to authentication
            let reason = "We need to unlock your data." // Customize the reason
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                if success {
                    // Authentication successful
                    // ... perform actions that require authentication
                    DispatchQueue.main.sync { [self] in
                        self.unlockSecretMesage()
                    }
                } else {
                    // Authentication failed
                    // Handle the error
                    if let error = error as NSError? {
                        // Handle specific errors (e.g., user cancelled, biometrics not recognized)
                        let ac = UIAlertController(title: "Authentication failed", message: error.localizedFailureReason, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(ac, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // Biometrics are not available or not enabled
            // Handle the case where biometrics are not available
            // Handle specific errors (e.g., user cancelled, biometrics not recognized)
            print("\(String(describing: error?.localizedFailureReason))")
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        
        
        
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMesage() {
        secret.isHidden = false
        title = "Secret stuff"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage", withAccessibility: nil)
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
}

