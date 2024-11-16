//
//  ActionViewController.swift
//  Extension
//
//  Created by Bruce on 2024/11/5.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    lazy var script2 =
"""
function addHeaderText(text, fontSize = '40px') {
    // Create new div element
    const headerDiv = document.createElement('div');
    
    // Set the text content
    headerDiv.textContent = text;
    
    // Style the div
    headerDiv.style.cssText = `
        font-size: ${fontSize};
        text-align: center;
        padding: 20px;
        width: 100%;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 9999;
        background-color: white;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    `;
    
    // Add to the beginning of the body
    document.body.insertBefore(headerDiv, document.body.firstChild);
    
    // Add padding to body to prevent overlap
    document.body.style.paddingTop =
        (parseInt(fontSize) + 40) + 'px'; // Account for padding
}

// Usage:
addHeaderText('Hello friend');
"""
    
    // Use javascript to show an alert with a button, when clicked jump to www.apple.com and
    // make the button show in front of the page. Created by claude.com
    lazy var script3 =
"""
  const button = document.createElement('button');
    button.textContent = 'Visit Apple';
    
    button.style.cssText = `
        /* Positioning */
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        z-index: 9999;
        
        /* Styling */
        padding: 12px 24px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        background-color: #0066cc;
        color: white;
        border: none;
        border-radius: 5px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        transition: all 0.3s ease;
    `;
    
    button.addEventListener('mouseover', function() {
        this.style.backgroundColor = '#004499';
        this.style.boxShadow = '0 4px 15px rgba(0, 0, 0, 0.3)';
    });
    
    button.addEventListener('mouseout', function() {
        this.style.backgroundColor = '#0066cc';
        this.style.boxShadow = '0 2px 10px rgba(0, 0, 0, 0.2)';
    });
    
    button.addEventListener('click', function() {
        if (confirm('Would you like to visit Apple.com?')) {
            window.location.href = 'https://www.apple.com';
        }
    });
    
    document.body.appendChild(button);
"""

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptToChooseScript))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjust), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjust), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier, options: nil) { [weak self] dict, error in
                    guard let itemDictionay = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionay[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        
                        if let pageURL = self?.pageURL,  let urlHost = URL(string: pageURL)?.host  {
                            if let savedScriptString = UserDefaults.standard.object(forKey: urlHost) as? String {
                                self?.script.text = savedScriptString
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func adjust(notif: NSNotification) {
        
        guard notif.name == UIResponder.keyboardWillHideNotification
                || notif.name == UIResponder.keyboardWillChangeFrameNotification else { return }

        if notif.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            guard let value = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let Screenframe = value.cgRectValue
            let frame = view.convert(Screenframe, from: view.window)
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset
        script.scrollRangeToVisible(script.selectedRange)
    }
    
    @objc func promptToChooseScript() {
        let ac = UIAlertController(title: "Choose a script", message: "Please choose a script", preferredStyle: .actionSheet)
        
        
        let action1 = UIAlertAction(title: "Show website title", style: .default, handler: { [weak self] _ in
            self?.script.text = "alert(document.title)"
        })
        
        let action2 = UIAlertAction(title: "Add a label at page top", style: .default, handler: { [weak self] _ in
            self?.script.text = self?.script2
        })
        
        let action3 = UIAlertAction(title: "Add a button to jump to apple.com", style: .default, handler: { [weak self] _ in
            self?.script.text = self?.script3
        })
        ac.addAction(action1)
        ac.addAction(action2)
        ac.addAction(action3)
        
        present(ac, animated: true, completion: nil)
    }
    
    

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier)
        item.attachments = [customJavaScript]
        self.extensionContext!.completeRequest(returningItems: [item])
        
        if let hostURL = URL(string: pageURL), let hostString = hostURL.host {
            UserDefaults.standard.set(script.text, forKey: hostString)
        }
    }

}
