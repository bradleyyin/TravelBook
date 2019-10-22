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
        controller.loadTrips()
        
    }


}

