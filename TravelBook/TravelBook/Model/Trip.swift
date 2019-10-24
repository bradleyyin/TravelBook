//
//  Trip.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import MapKit

class Trip: NSObject {
    let latitude: Double
    let longitude: Double
    let name: String
    let id: String
    
    init(latitude: Double, longitude: Double, name: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.id = UUID().uuidString
    }
    
    
    init(with dictionary: [String: Any]) {
        print(dictionary)
        self.latitude = dictionary["latitude"] as! Double
        self.longitude = dictionary["longitude"] as! Double
        self.name = dictionary["name"] as! String
        self.id = dictionary["id"] as! String
    }
    
    func toDictionary() -> [String: Any] {
        return ["latitude": latitude, "longitude": longitude, "name": name, "id": id]
    }
}

extension Trip: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
       return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var title: String? {
        return name
    }
    
    
}
