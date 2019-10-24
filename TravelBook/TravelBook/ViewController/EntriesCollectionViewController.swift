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
    var controller: TravelBookController!
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if controller.travelCache.values(forKey: trip.id) == nil {
            controller.loadEntries(for: trip) { (_) in
                DispatchQueue.main.async {
                    self.entryCollectionView.reloadData()
                }
            }
            
        }
        entryCollectionView.dataSource = self
        entryCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadEntries), name: Notification.Name.init(rawValue: "entriesReeload"), object: nil)
    }
    @objc func reloadEntries() {
        self.entryCollectionView.reloadData()
    }
    
   
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
}

extension EntriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return controller.travelCache.values(forKey: trip.id)?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EntryCell", for: indexPath) as? EntryCollectionViewCell, let entry = controller.travelCache.values(forKey: trip.id)?[indexPath.row] as? Entry else { return UICollectionViewCell() }
        
        cell.controller = controller
        cell.entry = entry
        cell.trip = trip
        

        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return UIScreen.main.bounds.size
//    }

}

