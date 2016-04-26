//
//  TagDetailViewController.swift
//  MealTracker
//
//  Created by Valti Skobo on 03/04/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit

import Foundation
import MobileCoreServices
import Foundation
import AVFoundation

import GPUImage
import OAuthSwift
import CoreData

import SwiftHEXColors

class TagDetailViewController: UIViewController{
    
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tempDescArray = (gArrDescription != nil) ? NSMutableArray(array: gArrDescription) : NSMutableArray()
    
    var expandedIndexPath: NSIndexPath? {
        didSet {
            switch expandedIndexPath {
            case .Some(let index):
                tagTableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
            case .None:
                tagTableView.reloadRowsAtIndexPaths([oldValue!], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagTableView.rowHeight = UITableViewAutomaticDimension
        tagTableView.estimatedRowHeight = 145
        tagTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        searchBar.text = gSearchBarText
        
        if gSearchBarText.compare("") != NSComparisonResult.OrderedSame{
            expandedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        }
        
        loadTable(searchBar.text!)
    }
    
    func loadTable(searchString: String){
        tempDescArray.removeAllObjects()
        
        for item in gArrDescription{
            let itemData = item as! NSDictionary
            
            var tagString = itemData.valueForKey("Tag Name") as! String
            tagString = tagString.lowercaseString
            
            if tagString.containsString(searchString.lowercaseString) == true{
                print(itemData.valueForKey("Tag Name") as! String)
                
                tempDescArray.addObject(itemData)
            }
            else if searchBar.text?.compare("") == NSComparisonResult.OrderedSame{
                tempDescArray.addObject(itemData)
            }
            
        }
        
        tagTableView.reloadData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func goHome(){
        print("Home Button")
        
        if gSearchBarText.compare("") != NSComparisonResult.OrderedSame{
            gSearchBarText = ""
            if let parentVC = self.parentViewController {
                if let parentVC = parentVC as? SnapChatPageViewController{
                    parentVC.goHistory(false)
                }
            }
        }
        else{
            if let parentVC = self.parentViewController {
                if let parentVC = parentVC as? SnapChatPageViewController{
                    parentVC.goHome(false)
                }
            }
        }
        
    }
    
    @IBAction func goFoodPhilosophy(){
        print("Information Button")
        if let parentVC = self.parentViewController {
            if let parentVC = parentVC as? SnapChatPageViewController{
                parentVC.goPhilosophy(true)
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension TagDetailViewController : UISearchBarDelegate{
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        loadTable(searchText)
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
}


//MARK: - UITableViewDataSource

extension TagDetailViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gGetJSON == 0{
            return 0
        }
        return tempDescArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let res = tableView.dequeueReusableCellWithIdentifier("ExpandableCell", forIndexPath: indexPath) as! ExpandableTableViewCell
        
        res.tagName.text = tempDescArray[indexPath.row].valueForKey("Tag Name") as? String
        res.subTitle.text = tempDescArray[indexPath.row].valueForKey("Subtitle") as? String
        res.textDescription.text = tempDescArray[indexPath.row].valueForKey("Description") as? String
        
        res.dotHeader.textColor = UIColor(hexString: (tempDescArray[indexPath.row].valueForKey("Color") as? String)!)
        res.subTitle.textColor = UIColor(hexString: (tempDescArray[indexPath.row].valueForKey("Color") as? String)!)
        
        switch expandedIndexPath {
        case .Some(let expandedIndexPath) where expandedIndexPath == indexPath:
            res.arrowImage.image = UIImage.init(named: "up")
            res.showsDetails = true
        default:
            res.arrowImage.image = UIImage.init(named: "down")
            res.showsDetails = false
        }
        
        return res
    }
}

//MARK: - UITableViewDelegate

extension TagDetailViewController: UITableViewDelegate {
    
    //func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //}
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        switch expandedIndexPath {
        case .Some(_) where expandedIndexPath == indexPath:
            expandedIndexPath = nil
        case .Some(let expandedIndex) where expandedIndex != indexPath:
            expandedIndexPath = nil
            self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        default:
            expandedIndexPath = indexPath
        }
    }
}