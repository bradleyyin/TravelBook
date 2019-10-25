//
//  PostCollectionViewController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/23/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PostCollectionViewController: UICollectionViewController {
    var controller: TravelBookController!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosts), name: Notification.Name.init(rawValue: "tripsReload"), object: nil)

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    @objc func reloadPosts() {
        self.collectionView.reloadData()
    }

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPostShowSegue" {
            guard let addVC = segue.destination as? AddPostViewController else { return }
            addVC.controller = controller
        } else if segue.identifier == "PostToEntryShowSegue" {
            guard let entryVC = segue.destination as? EntriesViewController, let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            entryVC.trip = controller.trips[indexPath.item]
            entryVC.controller = controller
        }
    }
  

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.trips.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell()}
        let trip = controller.trips[indexPath.row]
    
        cell.trip = trip
        loadPhoto(for: cell, trip: trip)
    
        return cell
    }
    
    private func loadPhoto(for cell: PostCollectionViewCell, trip: Trip) {
        if let entry = controller.travelCache.values(forKey: trip.id)?.last as? Entry {
            
            guard let photoURLString = entry.photoURLStrings.last, let url = URL(string: photoURLString) else { return }
            
            self.controller.loadPhoto(at: url) { (photo, error) in
                if let error = error {
                    print("error loading photo: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    //cell.imageView.image = photo
                }
                
            }
            
        } else {
            controller.loadEntries(for: trip) { (error) in
                if let error = error {
                    print("Error loading entries: \(error)")
                    return
                }
                guard let entry = self.controller.travelCache.values(forKey: trip.id)?.last as? Entry else { return }
                guard let photoURLString = entry.photoURLStrings.last, let url = URL(string: photoURLString) else { return }
                self.controller.loadPhoto(at: url) { (photo, error) in
                    if let error = error {
                        print("error loading photo: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageView.image = photo
                    }
                }
            }

        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
