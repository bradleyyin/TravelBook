//
//  PostNavigationController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/23/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class PostNavigationController: UINavigationController {
    var controller: TravelBookController!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let postCollectionVC = self.viewControllers[0] as? PostTableViewController else { return }
        postCollectionVC.controller = controller
    }
}
