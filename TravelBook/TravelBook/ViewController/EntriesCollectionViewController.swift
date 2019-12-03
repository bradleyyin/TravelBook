//
//  EntriesCollectionViewController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EntryCell"

class EntriesViewController: UIViewController {
    @IBOutlet var entryCollectionView: UICollectionView!
    
    var trip: Trip!
    var entries: [Entry] = []
    var controller: TravelBookController!

    override func viewDidLoad() {
        super.viewDidLoad()
        if controller.travelCache.values(forKey: trip.id) == nil {
            controller.loadEntries(for: trip) { (_) in
                self.entries = self.controller.travelCache.values(forKey: self.trip.id) as! [Entry]
                self.entries.sort(by: {$0.date.compare($1.date) == .orderedDescending})
                DispatchQueue.main.async {
                    self.entryCollectionView.reloadData()
                }
            }
            
        } else {
            self.entries = self.controller.travelCache.values(forKey: self.trip.id) as! [Entry]
            self.entries.sort(by: {$0.date.compare($1.date) == .orderedAscending})
            DispatchQueue.main.async {
                self.entryCollectionView.reloadData()
            }
        }
        entryCollectionView.dataSource = self
        entryCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadEntries), name: Notification.Name.init(rawValue: "entriesReload"), object: nil)
    }
    @objc func reloadEntries() {
        self.entries = self.controller.travelCache.values(forKey: self.trip.id) as! [Entry]
        entries.sort(by: {$0.date.compare($1.date) == .orderedDescending})
        self.entryCollectionView.reloadData()
    }
    
   
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEntryShowSegue" {
            guard let addEntryVC = segue.destination as? AddEntryViewController else { return }
            addEntryVC.controller = controller
            addEntryVC.trip = trip
        }
    }
    

    
}

extension EntriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return entries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EntryCell", for: indexPath) as? EntryCollectionViewCell else { return UICollectionViewCell() }
        let entry = entries[indexPath.row]
        cell.controller = controller
        cell.entry = entry
        cell.trip = trip
        

        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return UIScreen.main.bounds.size
//    }

}

