//
//  ViewController.swift
//  Project 10
//
//  Created by Bruce on 2024/10/13.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "people") as? Data {
            if let array = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: Person.self, from: data) {
                    people = array
            }
        }
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: imagePath)
        }
        
        let person = Person(name: "unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as? PersonCell else {
            fatalError("Can not load PersonCell")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor.init(white: 0, alpha: 0.8).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        
        cell.layer.cornerRadius = 7
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let chooseAc = UIAlertController(title: "Choose one", message: "", preferredStyle: .alert)
        
        chooseAc.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            // Remove from disk
            guard let path = self?.getDocumentsDirectory().appendingPathComponent(person.image) else { return }
            do {
                try FileManager.default.removeItem(at: path)
            } catch {
                return
            }
            
            // remove from array
            self?.people.remove(at: indexPath.item)
            self?.save()
            
            // update ui
            collectionView.reloadData()
        }))
        
        chooseAc.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in
            let ac = UIAlertController(title: "Input a name", message: "Please type a name for the picture", preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                guard let tf = ac.textFields?[0] else { return }
                
                if let text = tf.text {
                    person.name = text
                    self?.save()
                    self?.collectionView.reloadData()
                }
            }))
            
            self?.present(ac, animated: true)
        }))
        
        chooseAc.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(chooseAc, animated: true)
    }
    
    func save() {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: true) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "people")
        }
    }
}

