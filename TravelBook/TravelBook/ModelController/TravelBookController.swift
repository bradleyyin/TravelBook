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
    var travelCache = BYCache()
    let storageRef = Storage.storage().reference()
    let fireStoreRef = Firestore.firestore()
    let userID = "rwrxHDC1HTy0EtYcDBu4"
    
    //    init() {
    //        loadTrips { (error) in
    //            if let error = error {
    //                print("error loading trip: \(error)")
    //                return
    //            }
    //
    //
    //        }
    //    }
    
    func loadEntries(for trip: Trip, completion: @escaping (Error?) -> Void) {
        //guard let userID = Auth.auth().currentUser?.uid else { return }
        fireStoreRef.collection("user").document(userID).collection("trip").document(trip.id).collection("entry").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            guard let snapshot = snapshot else {
                print("no snapshot when loading entry")
                return
            }
            var entries: [Entry] = []
            for documentSnapshot in snapshot.documents {
                let dictionary = documentSnapshot.data()
                let entry = Entry.init(with: dictionary)
                entries.append(entry)
            }
            
            self.travelCache.cacheValues(forKey: trip.id, values: entries)
            print("load entries")
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "entriesReeload"), object: nil)
            completion(nil)
        }
    }
    
    //    func loadLatestPhotoURL(for trip: Trip, completion: @escaping (String?, Error?) -> Void) {
    //        //guard let userID = _auth.currentUser?.uid else { return }
    //        fireStoreRef.collection("user").document("rwrxHDC1HTy0EtYcDBu4").collection("trip").document(trip.id).collection("entry").getDocuments { (documentSnapshots, error) in
    //            if let error = error {
    //                print(error)
    //                completion(nil, error)
    //                return
    //            }
    //            guard let documentSnapshots = documentSnapshots else {
    //                print("no snapshot when loading latest entry")
    //                completion(nil, nil)
    //                return
    //            }
    //            let dictionary = documentSnapshots.documents.last?.data()
    //            let photoURLStrings = dictionary?["photoURLStrings"] as! [String]
    //            let latestPhotoURLString = photoURLStrings.last
    //            completion(latestPhotoURLString, nil)
    //        }
    //    }
    
    func loadPhoto(at url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil,nil)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
        }.resume()
    }
    
    func uploadPhoto(photo: UIImage, completion: @escaping (URL?) -> Void) {
        
        //guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let photoID = UUID().uuidString
        
        let photoRef = storageRef.child("photos").child(userID).child(photoID)
        guard let photoData = photo.pngData() else { return }
        
        let uploadTask = photoRef.putData(photoData, metadata: nil) { (metadata, error) in
            if let error = error {
                NSLog("Error storing media data: \(error)")
                completion(nil)
                return
            }
            
            if metadata == nil {
                NSLog("No metadata returned from upload task.")
                completion(nil)
                return
            }
            
            photoRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    NSLog("Error getting download url of media: \(error)")
                }
                
                guard let url = url else {
                    NSLog("Download url is nil. Unable to create a Media object")
                    
                    completion(nil)
                    return
                }
                completion(url)
            })
        }
        
        uploadTask.resume()
    }
    
    //    func uploadPhotos(photos: [UIImage], completion: @escaping ([String]) -> Void) {
    //        let dispatchGroup = DispatchGroup()
    //        var photoURLStrings: [String] = []
    //        for photo in photos {
    //            dispatchGroup.enter()
    //            uploadPhoto(photo: photo) { (url) in
    //                guard let url = url else { return }
    //                let photoURLString = url.path
    //                photoURLStrings.append(photoURLString)
    //                dispatchGroup.leave()
    //            }
    //        }
    //        dispatchGroup.wait()
    //        completion(photoURLStrings)
    //    }
    
    func addEntry(to trip: Trip, entry: Entry, completion: @escaping () -> Void = {}) {
        //guard let userID = Auth.auth().currentUser?.uid else { return }
        fireStoreRef.collection("user").document(userID).collection("trip").document(trip.id).collection("entry").document(entry.id).setData(entry.toDictionary(), completion: { (error) in
            if let error = error {
                fatalError("fail to add entry: \(error)")
            }
            completion()
        })
    }
    
    func loadTrips() {
        //guard let userID = Auth.auth().currentUser?.uid else { return }
        fireStoreRef.collection("user").document(userID).collection("trip").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("error loading trips:\(error)")
                return
            }
            guard let snapshot = snapshot else { return }
            self.trips.removeAll()
            for documentSnapshot in snapshot.documents {
                let dictionary = documentSnapshot.data()
                let trip = Trip.init(with: dictionary)
                self.trips.append(trip)
                
            }
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "tripsReload"), object: nil)
        }
        
    }
    
    func addTrip(trip: Trip) {
        //guard let userID = Auth.auth().currentUser?.uid else { return }
        fireStoreRef.collection("user").document(userID).collection("trip").document(trip.id).setData(trip.toDictionary()) { (error) in
            if let error = error {
                fatalError("fail to add trip: \(error)")
            }
        }
    }
}
