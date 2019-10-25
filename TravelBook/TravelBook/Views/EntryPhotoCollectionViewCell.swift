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
    override func layoutSubviews() {
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    private func setupViews() {
        imageViewWidthAnchor.constant = contentView.bounds.width
        imageViewHeightAnchor.constant = imageViewWidthAnchor.constant
        imageView.image = photo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
