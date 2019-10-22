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
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.controller.trips)
            }
            
        }
        
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // TODO: figure out how to handle multiple annoations if required ...
        guard let trip = annotation as? Trip else { fatalError("Invalid type") }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "TripView") as? MKMarkerAnnotationView else { fatalError("Incorrect view is registered")
        }
        
        annotationView.canShowCallout = true
        let detailView = TripView()
        detailView.trip = trip
        detailView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        detailView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        controller.loadLatestPhotoURL(for: trip) { (photoURLString, error) in
            if let error = error {
                print("Error loading photoURL String: \(error)")
                return
            }
            guard let photoURLString = photoURLString, let url = URL(string: photoURLString) else { return }
            self.controller.loadPhoto(at: url) { (photo, error) in
                if let error = error {
                    print("error loading photo: \(error)")
                    return
                }
                detailView.photo = photo
            }
        }
        
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}
