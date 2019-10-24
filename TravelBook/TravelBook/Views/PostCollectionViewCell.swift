//
//  PostCollectionViewCell.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/23/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var trip: Trip? {
        didSet {
            updateViews()
        }
    }
    private func updateViews() {
        guard let trip = trip else { return }
        
        nameLabel.text = trip.name
    }
}
