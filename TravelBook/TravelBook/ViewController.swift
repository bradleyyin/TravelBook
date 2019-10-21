//
//  ViewController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let controller = TravelBookController()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("date\(Date())")
        let entry = Entry(date: Date(), latitude: 122, longitude: 33, photoURLStrings: ["https://firebasestorage.googleapis.com/v0/b/travelbook-5e13e.appspot.com/o/photos%2FrwrxHDC1HTy0EtYcDBu4%2Fviolin.jpeg?alt=media&token=737740d9-3350-422e-add1-431ad977b0c6"], notes: "this test")
        controller.addEntry(entry: entry) {
            print("complete add")
        }
        //controller.loadEntries()
        //print(controller.entries)
        // Do any additional setup after loading the view.
    }


}

