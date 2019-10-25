//
//  EntryDetailViewController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/23/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var photoTableView: UITableView!
    @IBOutlet weak var noteTextView: UITextView!
    
    var entry: Entry?
    var trip: Trip!
    var controller: TravelBookController!
    var photos: [UIImage] = []
    var photoURLStrings: [String] = []
    var datePicker: UIDatePicker!
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoTableView.delegate = self
        photoTableView.dataSource = self
        self.datePicker = UIDatePicker()
        showDatePicker()
        updateViews()
        noteTextView.delegate = self
        noteTextView.textColor = .lightGray
        photoTableView.separatorStyle = .none
        setupImagePicker()
        loadPhotos()
        
        
        // Do any additional setup after loading the view.
    }
    
    private func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    func updateViews() {
        if let entry = entry{
            dateTextField.text = formatter.string(from: entry.date)
            noteTextView.text = entry.notes
        } else {
            dateTextField.text = formatter.string(from: Date())
        }
    }
    
    func showDatePicker(){
        //format date
        if let date = entry?.date{
            datePicker.date = date
        }
        datePicker.datePickerMode = .dateAndTime
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
        photoURLStrings = entry.photoURLStrings
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
                        self.photoTableView.reloadData()
                    }
                }
            }
        } else {
            photos = controller.travelCache.values(forKey: entry.id) as? [UIImage] ?? []
            self.photoTableView.reloadData()
        }
        
    }
    @IBAction func addPhoto(_ sender: Any) {
        self.present(imagePicker, animated: true)
    }
    @IBAction func saveEntry(_ sender: Any) {
        guard photoURLStrings.count == photos.count, let notes = noteTextView.text, let title = titleTextField.text else { print("string not same count"); return }
        let date = datePicker.date
        
        
        if var entry = self.entry {
            entry.photoURLStrings = photoURLStrings
            entry.notes = notes
            entry.date = date
            self.controller.addEntry(to: self.trip, entry: entry)
            controller.travelCache.cacheValues(forKey: entry.id, values: photos)
            self.navigationController?.popViewController(animated: true)
        } else {
            let entry = Entry(date: date, photoURLStrings: photoURLStrings, notes: notes, title: title)
            self.controller.addEntry(to: self.trip, entry: entry)
            controller.travelCache.cacheValues(forKey: entry.id, values: photos)
            self.navigationController?.popViewController(animated: true)
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

extension AddEntryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        cell.photoImageView.image = photos[indexPath.row].resizeImage(targetSize: CGSize(width: 300, height: 300))
        
        return cell
    }
    
    
    
}

extension AddEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            photos.append(userPickedImage)
            controller.uploadPhoto(photo: userPickedImage) { (url) in
                guard let url = url else { return }
                
                self.photoURLStrings.append(url.absoluteString)
            }
            imagePicker.dismiss(animated: true) {
                self.photoTableView.reloadData()
            }
        }
    }
}

extension AddEntryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
}
