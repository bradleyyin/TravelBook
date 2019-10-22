//
//  TripView.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/22/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class TripView: UIView {

    private let nameLabel = UILabel()
    private let photoImageView = UIImageView()
    
    var trip: Trip? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    private func setupSubViews() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30).isActive = true
        photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20).isActive = true
    }
    
    private func updateViews() {
        guard let trip = trip else { return }
        nameLabel.text = trip.name
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
