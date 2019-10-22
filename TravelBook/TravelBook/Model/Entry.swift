//
//  Entry.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

struct Entry {
    let date: Date
    let photoURLStrings: [String]
    let notes: String
    let id: String
    
    init(date: Date, photoURLStrings: [String], notes: String) {
        self.date = date
        self.photoURLStrings = photoURLStrings
        self.notes = notes
        self.id = UUID().uuidString
    }
    
    init(with dictionary: [String: Any]) {
        self.date = Date()
        self.photoURLStrings = dictionary["photoURLStrings"] as! [String]
        self.notes = dictionary["notes"] as! String
        self.id = dictionary["id"] as! String
    }
    
    func toDictionary() -> [String: Any] {
        return ["date": date, "photoURLStrings": photoURLStrings, "notes": notes, "id": id]
    }
    
}
