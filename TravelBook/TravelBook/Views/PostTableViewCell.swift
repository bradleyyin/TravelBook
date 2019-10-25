//
//  PostTableViewCell.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var shadedView: UIView!
    var trip: Trip? {
        didSet {
            updateViews()
        }
    }
    private func updateViews() {
        guard let trip = trip else { return }
        
        nameLabel.text = trip.name
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 20
        photoImageView.clipsToBounds = true
        shadedView.layer.cornerRadius = 20
        shadedView.clipsToBounds = true
    }
    override func prepareForReuse() {
           super.prepareForReuse()
           photoImageView.image = nil
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
