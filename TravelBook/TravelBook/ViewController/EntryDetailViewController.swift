//
//  EntryDetailViewController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/23/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var noteTextView: UITextView!
    
    var entry: Entry?
    var controller: TravelBookController!
    var photos: [UIImage] = []
    var datePicker: UIDatePicker!
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        self.datePicker = UIDatePicker()
        showDatePicker()
        updateViews()
        loadPhotos()
        
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        dateTextField.text = formatter.string(from: entry.date)
        noteTextView.text = entry.notes
    }
    
    func showDatePicker(){
        //format date
        if let date = entry?.date{
            datePicker.date = date
        }
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date(timeIntervalSinceReferenceDate: 0)
    
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,space,doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    @objc func doneDatePicker(){
        
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func loadPhotos() {
        guard let entry = entry else { return }
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
                    }
                }
            }
        } else {
            photos = controller.travelCache.values(forKey: entry.id) as? [UIImage] ?? []
            self.photoCollectionView.reloadData()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EntryDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = photos[indexPath.row].resizeImage(targetSize: CGSize(width: 100, height: 100))
        
        return cell
        
    }
    
    
}
