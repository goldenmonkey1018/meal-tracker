//
//  RootViewController.swift
//  MealTracker
//
//  Created by Valti Skobo on 31/03/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class RootViewController: UIViewController{

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    var mProgress: MBProgressHUD!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let welcomePageViewController = segue.destinationViewController as? WelcomePageViewController {
            welcomePageViewController.welcomeDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 60/255.0, green: 1, blue: 143/255.0, alpha: 1)
        
        sendToService()
    }
    
    func showLoading() {
        mProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        mProgress.mode = MBProgressHUDMode.Indeterminate
        mProgress.labelText = "Connecting Server..."
        
        mProgress.show(true)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onTerms(){
       let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcTermsViewController") as? TermsViewController
        //self.navigationController?.pushViewController(vc!, animated: true)
        self.presentViewController(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func onPolicy(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcPrivacyViewController") as? PrivacyViewController
        //self.navigationController?.pushViewController(vc!, animated: true)
        self.presentViewController(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func onGetStarted(){
        if gGetJSON == 1{
            //let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcHomeViewController") as? HomeViewController
            
            gReadTermAlready = 1
            
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(gReadTermAlready), forKey: "ReadTermAlready")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcSnapChatPageViewController") as? SnapChatPageViewController
            
            self.presentViewController(vc!, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func sendToService(){
        
        //showLoading()
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: "https://sheetsu.com"))
        manager.GET(
            "https://sheetsu.com/apis/f6e2ef8c",
            parameters: nil,
            progress: nil,
            success: { task, responseObject in
                
                //print(responseObject)
                let response = responseObject as! NSDictionary
                let arrObj: NSMutableArray = response.objectForKey("result") as! NSMutableArray
                
                gArrDescription = arrObj
                gGetJSON = 1
                //self.mProgress.hide(true)
                
                print(gArrDescription[3].valueForKey("Color"))
                for item in arrObj{
                    let itemData = item as! NSDictionary
                    print(itemData)
                }
                NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(gArrDescription), forKey: "ArrDescription")
                
                NSUserDefaults.standardUserDefaults().synchronize()
            },
            failure: { task, error in
                //self.mProgress.hide(true)
                print("Error: " + error.localizedDescription)
        })
    }
    
}

extension RootViewController: WelcomePageViewControllerDelegate {
    
    func welcomePageViewController(welcomePageViewController: WelcomePageViewController,
        didUpdatePageCount count: Int) {
            pageControl.numberOfPages = count
    }
    
    func welcomePageViewController(welcomePageViewController: WelcomePageViewController,
        didUpdatePageIndex index: Int) {
            pageControl.currentPage = index
    }
    
}