//
//  NavigationController.swift
//  MealTracker
//
//  Created by Valti Skobo on 06/04/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func prefersStatusBarHidden() -> Bool {
        if let topVC = self.visibleViewController {
            print(topVC.prefersStatusBarHidden())
            return topVC.prefersStatusBarHidden()
        }
        return false
    }
}
