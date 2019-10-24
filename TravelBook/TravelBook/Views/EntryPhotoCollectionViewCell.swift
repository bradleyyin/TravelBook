//
//  EntryPhotoCollectionViewCell.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class EntryPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewWidthAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    var photo: UIImage? {
        didSet {
            setupViews()
        }
    }
    private func setupViews() {
        imageViewWidthAnchor.constant = UIScreen.main.bounds.size.width
        imageViewHeightAnchor.constant = imageViewWidthAnchor.constant
        
        imageView.image = photo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
