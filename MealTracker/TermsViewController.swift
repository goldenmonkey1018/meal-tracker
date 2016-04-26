//
//  TermsViewController.swift
//  MealTracker
//
//  Created by Valti Skobo on 09/04/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import Foundation
import UIKit

class TermsViewController: UIViewController{
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "http://www.google.com")
        //let url = NSURL (string: "http://www.mealtracker.io/terms-ios")
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func goBack(){
        //let vc = self.storyboard?.instantiateViewControllerWithIdentifier("WelcomeViewController") as? RootViewController

        //self.presentViewController(vc!, animated: true, completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}