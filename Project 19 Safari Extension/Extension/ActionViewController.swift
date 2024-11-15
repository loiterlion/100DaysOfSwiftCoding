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
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
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

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier)
        item.attachments = [customJavaScript]
        self.extensionContext!.completeRequest(returningItems: [item])
    }

}
