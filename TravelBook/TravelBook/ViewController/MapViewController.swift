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
    var selectedTrip: Trip!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "TripView")
        //mapView.addAnnotations(controller.trips)
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
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("select")
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // TODO: figure out how to handle multiple annoations if required ...
        guard let trip = annotation as? Trip else { fatalError("Invalid type") }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "TripView") as? MKMarkerAnnotationView else { fatalError("Incorrect view is registered")
        }
        
        annotationView.canShowCallout = true
        let detailView = TripView()
        detailView.trip = trip
        detailView.delegate = self
        detailView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        detailView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        controller.loadEntries(for: trip) { (error) in
            if let error = error {
                print("Error loading entries: \(error)")
                return
            }
            guard let entry = self.controller.tripEntriesCache.entries(forKey: trip.id)?.last as? Entry else { return }
            guard let photoURLString = entry.photoURLStrings.last, let url = URL(string: photoURLString) else { return }
            self.controller.loadPhoto(at: url) { (photo, error) in
                if let error = error {
                    print("error loading photo: \(error)")
                    return
                }
                detailView.photo = photo
                DispatchQueue.main.async {
                    mapView.selectAnnotation(annotation, animated: true)
                    //annotationView.image = photo?.resizeImage(targetSize: CGSize(width: 100, height: 100))
                    //annotationView.glyphImage = nil
                    //annotationView.glyphTintColor = .clear
                    //annotationView.markerTintColor = .clear
                    
                }
            }
        }
        
        annotationView.detailCalloutAccessoryView = detailView

        return annotationView
    }
    
}

extension MapViewController: TripViewDelegate {
    func didTapImage(trip: Trip) {
        selectedTrip = trip
        performSegue(withIdentifier: "MapToEntryShowSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapToEntryShowSegue" {
            guard let entryListVC = segue.destination as? EntryListTableViewController else { return }
            entryListVC.trip = selectedTrip
            entryListVC.controller = controller
        }
    }
}
