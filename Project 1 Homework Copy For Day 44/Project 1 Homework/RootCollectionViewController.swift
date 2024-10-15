//
//  RootCollectionViewController.swift
//  Project 1 Homework
//
//  Created by Bruce on 2024/10/15.
//

import UIKit

private let reuseIdentifier = "NSSLCell"

class RootCollectionViewController: UICollectionViewController {
    var imageNames = [String]()
    
    fileprivate func loadPhotos() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            let resourcePath = Bundle.main.resourcePath!
            self.imageNames = try! FileManager.default.contentsOfDirectory(atPath: resourcePath + "/Content")
            self.imageNames = self.imageNames.sorted(by: <)
            
            DispatchQueue.main.async { [weak self] in
                print("tableView reload data")
                self?.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPhotos()
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCell else { fatalError("Cannot dequeue cell!!")}
    
        let imageName = imageNames[indexPath.item]
        cell.imageView.image = UIImage(named: imageName)
        cell.label.text = imageName
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.imageName = imageNames[indexPath.row]
            vc.title = "Picture \(indexPath.row + 1) of \(imageNames.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
