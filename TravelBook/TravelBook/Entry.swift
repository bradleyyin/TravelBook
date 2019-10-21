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
    let latitude: Double
    let longitude: Double
    let photoURLStrings: [String]
    let notes: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case latitude
        case longitude
        case photoURLStrings
        case notes
        case id
    }
    
    init(date: Date, latitude: Double, longitude: Double, photoURLStrings: [String], notes: String) {
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.photoURLStrings = photoURLStrings
        self.notes = notes
        self.id = UUID().uuidString
    }
    
    init(with dictionary: [String: Any]) {
        self.date = Date()
        self.latitude = dictionary["latitude"] as! Double
        self.longitude = dictionary["longitude"] as! Double
        self.photoURLStrings = dictionary["photoURLStrings"] as! [String]
        self.notes = dictionary["notes"] as! String
        self.id = dictionary["id"] as! String
    }
    
    func toDictionary() -> [String: Any] {
        return ["date": date, "latitude": latitude, "longitude": longitude, "photoURLStrings": photoURLStrings, "notes": notes, "id": id]
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        date = try container.decode(Date.self, forKey: .date)
//        latitude = try container.decode(Double.self, forKey: .latitude)
//        longitude = try container.decode(Double.self, forKey: .longitude)
//        photoURLStrings = try container.decode([String].self, forKey: .photoURLStrings)
//        notes = try container.decode(String.self, forKey: .notes)
//
//    }
    
    
}
