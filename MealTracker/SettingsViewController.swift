//
//  SettingsViewController.swift
//  MealTracker
//
//  Created by Sergey Rashidov on 13/04/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate{
    @IBOutlet weak var switchCtl: UISwitch!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var feedbackBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goHistory(sender: AnyObject!) {
        print("History Button")
        if let parentVC = self.parentViewController {
            if let parentVC = parentVC as? SnapChatPageViewController{
                parentVC.goHistory(true)
            }
        }
    }
    
    @IBAction func showEmail() { //sender : AnyObject
        let emailTitle = "MealTracker Feedback"
        let messageBody = ""
        let toRecipents = ["support@mealtracker.io"]
        
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            NSLog("Mail cancelled")
        case MFMailComposeResultSaved:
            NSLog("Mail saved")
        case MFMailComposeResultSent:
            NSLog("Mail sent")
        case MFMailComposeResultFailed:
            NSLog("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    
    @IBAction func onRateBtn(){
        print("rate")
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcRateViewController") as? RateViewController
        //self.navigationController?.pushViewController(vc!, animated: true)
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    
    
    
    @IBAction func switchChanged(){
        print("switch changed")
        print(switchCtl.on)
        gFlgSaveCameraRoll = switchCtl.on
        
    }
        
}

