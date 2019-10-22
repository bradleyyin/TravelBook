//
//  TravelBookController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class TravelBookController {
    
    var trips: [Trip] = []
    let storageRef = Storage.storage().reference()
    let fireStoreRef = Firestore.firestore()
    func loadEntries(for trip: Trip, completion: @escaping ([Entry]?, Error?) -> Void) {
        //guard let userID = _auth.currentUser?.uid else { return }
        fireStoreRef.collection("user").document("rwrxHDC1HTy0EtYcDBu4").collection("trip").document(trip.id).collection("entry").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            guard let snapshot = snapshot else {
                print("no snapshot when loading entry")
                completion(nil, nil)
                return
            }
            var entries: [Entry] = []
            for documentSnapshot in snapshot.documents {
                let dictionary = documentSnapshot.data()
                let entry = Entry.init(with: dictionary)
                entries.append(entry)
            }
            completion(entries, nil)
        }
    }
    
    func addEntry(entry: Entry, completion: @escaping () -> Void = {}) {
        fireStoreRef.collection("user").document("rwrxHDC1HTy0EtYcDBu4").collection("trip").document("Zc9qs7PHLFiyJBzrREXP").collection("entry").document(entry.id).setData(entry.toDictionary(), completion: { (error) in
            if let error = error {
                fatalError("fail to add entry: \(error)")
            }
            completion()
        })
    }
    
    func loadTrips() {
        //guard let userID = _auth.currentUser?.uid else { return }
        fireStoreRef.collection("user").document("rwrxHDC1HTy0EtYcDBu4").collection("trip").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
            }
            guard let snapshot = snapshot else { return }
            for documentSnapshot in snapshot.documents {
                let dictionary = documentSnapshot.data()
                let trip = Trip.init(with: dictionary)
                self.trips.append(trip)
                
            }
            print(self.trips)
        }
        
    }
}
