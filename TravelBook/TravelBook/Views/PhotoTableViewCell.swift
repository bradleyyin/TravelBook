//
//  PhotoTableViewCell.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
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
