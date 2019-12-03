//
//  EntryCollectionViewCell.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/24/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class EntryCollectionViewCell: UICollectionViewCell {
    var entry: Entry? {
        didSet {
            setupViews()
        }
    }
    @IBOutlet weak var photoCollectionViewHeightConstraint: NSLayoutConstraint!
    var trip: Trip!
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    var photos: [UIImage] = []
    var controller: TravelBookController!
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryNotesTextView: UITextView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    private func setupViews() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photos = []
        loadPhotos()
        //print(entry?.photoURLStrings.count)
        photoCollectionViewHeightConstraint.constant = CGFloat((entry?.photoURLStrings.count ?? 0)) * UIScreen.main.bounds.width
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photos = []
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let entry = entry else { return }
        dateLabel.text = dateFormatter.string(from: entry.date)
        locationLabel.text = trip.name
        entryTitleLabel.text = entry.title
        entryNotesTextView.text = entry.notes
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = UIScreen.main.bounds.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    
    func loadPhotos() {
        guard let entry = entry else { return }
        print("photostring number at \(entry.id)", entry.photoURLStrings.count)
        
        if controller.travelCache.values(forKey: entry.id) == nil {
            for photoString in entry.photoURLStrings {
                guard let url = URL(string: photoString) else { continue }
                controller.loadPhoto(at: url) { (photo, error) in
                    if let error = error {
                        print("Error loading photos \(error)")
                        return
                    }
                    guard let photo = photo else { return }
                    self.photos.append(photo)
                    DispatchQueue.main.async {
                        self.photoCollectionView.reloadData()
                        //self.photoCollectionViewHeightConstraint.constant += 300
                        //self.photoCollectionView.layoutIfNeeded()
                    }
                }
            }
        } else {
            print("load photos from cache")
            photos = controller.travelCache.values(forKey: entry.id) as? [UIImage] ?? []
            self.photoCollectionView.reloadData()
            //self.photoCollectionViewHeightConstraint.constant += 300
            //self.photoCollectionView.layoutIfNeeded()
        }
        
    }
    
}

extension EntryCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photos.count)
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EntryPhotoCell", for: indexPath) as? EntryPhotoCollectionViewCell else { return UICollectionViewCell() }
        if !photos.isEmpty {
            let photo = photos[indexPath.item]
            cell.photo = photo
        }
        
        return cell
        
    }
    
    
}
