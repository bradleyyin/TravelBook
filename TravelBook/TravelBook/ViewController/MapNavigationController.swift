//
//  MapNavigationController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/23/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class MapNavigationController: UINavigationController {
    var controller: TravelBookController!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mapVC = self.viewControllers[0] as? MapViewController else { return }
        mapVC.controller = controller
    }
}
