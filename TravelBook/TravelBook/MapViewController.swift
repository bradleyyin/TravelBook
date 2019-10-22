//
//  MapViewController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/22/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let controller = TravelBookController()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "TripView")
        controller.loadTrips { (error) in
            if let error = error {
                print("Error loading trip: \(error)")
                return
            }
            
        }
        
    }

}

extension MapViewController: MKMapViewDelegate {
    
}
