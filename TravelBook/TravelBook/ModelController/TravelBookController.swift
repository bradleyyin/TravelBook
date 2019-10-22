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
    
    func loadLatestPhotoURL(for trip: Trip, completion: @escaping (String?, Error?) -> Void) {
        //guard let userID = _auth.currentUser?.uid else { return }
        fireStoreRef.collection("user").document("rwrxHDC1HTy0EtYcDBu4").collection("trip").document(trip.id).collection("entry").getDocuments { (documentSnapshots, error) in
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            guard let documentSnapshots = documentSnapshots else {
                print("no snapshot when loading latest entry")
                completion(nil, nil)
                return
            }
            let dictionary = documentSnapshots.documents.last?.data()
            let photoURLStrings = dictionary?["photoURLStrings"] as! [String]
            let latestPhotoURLString = photoURLStrings.last
            completion(latestPhotoURLString, nil)
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
    
    func loadTrips(completion: @escaping (Error?) -> Void) {
        //guard let userID = _auth.currentUser?.uid else { return }
        fireStoreRef.collection("user").document("rwrxHDC1HTy0EtYcDBu4").collection("trip").addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            guard let snapshot = snapshot else { return }
            for documentSnapshot in snapshot.documents {
                let dictionary = documentSnapshot.data()
                let trip = Trip.init(with: dictionary)
                self.trips.append(trip)
                
            }
            completion(nil)
        }
        
    }
}
