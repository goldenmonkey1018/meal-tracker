//
//  RootViewController.swift
//  MealTracker
//
//  Created by Valti Skobo on 31/03/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit

class SnapChatViewController: UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let snapPageViewController = segue.destinationViewController as? SnapChatPageViewController {
            snapPageViewController.snapDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}

extension SnapChatViewController: SnapChatPageViewControllerDelegate {
    
    func snapchatPageViewController(snapchatPageViewController: SnapChatPageViewController,
        didUpdatePageCount count: Int) {
            //pageControl.numberOfPages = count
    }
    
    func snapchatPageViewController(snapchatPageViewController: SnapChatPageViewController,
        didUpdatePageIndex index: Int) {
            //pageControl.currentPage = index
    }
    
}