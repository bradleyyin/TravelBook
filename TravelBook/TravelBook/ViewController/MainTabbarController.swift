//
//  MainTabbarController.swift
//  TravelBook
//
//  Created by Bradley Yin on 10/23/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class MainTabbarController: UITabBarController {
    let controller = TravelBookController()
     override func viewDidLoad() {
           super.viewDidLoad()
           print(self.viewControllers)
           guard let postNavController = self.viewControllers?[0] as? PostNavigationController, let mapNavController = self.viewControllers?[1] as? MapNavigationController else { return }
           postNavController.controller = controller
           mapNavController.controller = controller
           
       }
    
}
