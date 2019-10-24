//
//  EntryListTableViewController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/22/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {
    
    var trip: Trip!
    var controller: TravelBookController!
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if controller.travelCache.values(forKey: trip.id) == nil {
            controller.loadEntries(for: trip) { (_) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadEntries), name: Notification.Name.init(rawValue: "entriesReeload"), object: nil)
        
    }
    
    @objc func reloadEntries() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return controller.travelCache.values(forKey: trip.id)?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        guard let entry = controller.travelCache.values(forKey: trip.id)?[indexPath.row] as? Entry else { return cell }
        
        cell.textLabel?.text = dateFormatter.string(from: entry.date)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EntryDetailShowSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController, let indexPath = tableView.indexPathForSelectedRow, let entry = controller.travelCache.values(forKey: trip.id)?[indexPath.row] as? Entry else { return }
            detailVC.entry = entry
            detailVC.controller = controller
            detailVC.trip = trip
            
        } else if segue.identifier == "AddEntryShowSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            detailVC.controller = controller
            detailVC.trip = trip
        }
    }
    

}
