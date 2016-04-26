//
//  TermsViewController.swift
//  MealTracker
//
//  Created by Valti Skobo on 09/04/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import Foundation
import UIKit

class FoodPhilosophyViewController: UIViewController{
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "http://www.mealtracker.io/food-philosophy-ios")
        //let url = NSURL (string: "http://www.sourcefreeze.com/")

        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // The appearance of the "Add Tags" view after taking a photo was disorienting.
    // Can you make this appear over the Home screen with a fade in, and also without 
    // changing the position of the image?
    @IBAction func goBack(){
        //self.navigationController?.popViewControllerAnimated(true)
        print("Detail Button")
        if let parentVC = self.parentViewController {
            if let parentVC = parentVC as? SnapChatPageViewController{
                gSearchBarText = ""
                parentVC.goDetail(false)
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}