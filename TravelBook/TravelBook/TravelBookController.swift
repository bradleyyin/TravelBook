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
    
    var entries : [Entry] = []
    let storageRef = Storage.storage().reference()
    let fireStoreRef = Firestore.firestore()
    func loadEntries() {
        //guard let userID = _auth.currentUser?.uid else { return }
        fireStoreRef.collection("user").document("rwrxHDC1HTy0EtYcDBu4").collection("trip").document("Zc9qs7PHLFiyJBzrREXP").collection("entry").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
            }
            guard let snapshot = snapshot else { return }
            for documentSnapshot in snapshot.documents {
                let dictionary = documentSnapshot.data()
                let entry = Entry.init(with: dictionary)
                self.entries.append(entry)
                
            }
            print(self.entries)
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
}
