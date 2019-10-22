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
    private var photoImageView: UIImageView!
    
    var trip: Trip? {
        didSet {
            updateViews()
        }
    }
    var photo: UIImage? {
        didSet {
            updatePhoto()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    private func setupSubViews() {
        //photoImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        self.addSubview(imageView)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        //nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        //nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        //imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        self.photoImageView = imageView
    }
    
    private func updateViews() {
        guard let trip = trip else { return }
        //nameLabel.text = trip.name
        
    }
    private func updatePhoto() {
        DispatchQueue.main.async {
            self.photoImageView.contentMode = .scaleAspectFit
            self.photoImageView.image = self.photo
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
