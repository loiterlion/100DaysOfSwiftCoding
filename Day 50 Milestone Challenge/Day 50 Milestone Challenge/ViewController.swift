//
//  ViewController.swift
//  Day 50 Milestone Challenge
//
//  Created by Bruce on 2024/10/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var imageName: String?
    var imageItems = [ImageItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Day 50 Challenge"
        
        if let savedData = UserDefaults.standard.object(forKey: "imageItems") as? Data {
            if let decoded = try? JSONDecoder().decode([ImageItem].self, from: savedData) {
                imageItems = decoded
            }
        }
        
        let addBBI = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptToAddPhoto))
        self.navigationItem.rightBarButtonItem = addBBI
    }

    @objc func promptToAddPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let imgURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
//        guard let image = UIImage(contentsOfFile: imgURL.path) else { return }
        
        // Is it the same with snippet above?
        guard let image = info[.originalImage] as? UIImage else { return }
        
        do {
            let url = getDocumentaryFolder().appendingPathComponent(UUID().uuidString)
            print(url)
            try image.jpegData(compressionQuality: 0.8)?.write(to: url)
            
            let imageName = url.lastPathComponent
            
            let ac = UIAlertController(title: "Type a name", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                if let tf = ac.textFields?[0] {
                    let imageItem = ImageItem(name: tf.text ?? "unknown", image: imageName)
                    self?.imageItems.insert(imageItem, at: 0)
                    self?.save()
                    
                    self?.dismiss(animated: true)
                    self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//                    self?.tableView.reloadData()
                }
            }))
            
            // This line is key to showing an alert over an image picker
            picker.present(ac, animated: true)
            
        } catch {
            fatalError("Error write image to disk")
        }
    }
    
    func getDocumentaryFolder() -> URL{
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageItem", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        let imageItem = imageItems[indexPath.row]
        content.text = imageItem.name
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        let imageName = imageItems[indexPath.row].image
        detailVC.imagePath = imageName
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(imageItems) {
            UserDefaults.standard.set(encoded, forKey: "imageItems")
        }
    }
}

