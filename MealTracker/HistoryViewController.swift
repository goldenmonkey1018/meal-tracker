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

import Analytics

class HistoryViewController: UIViewController{
    @IBOutlet weak var photoTableView : UITableView!
    
    @IBOutlet weak var pickView: UIView!
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var timePick: UIDatePicker!
    @IBOutlet weak var doneBtn: UIButton!
    
    var updateFileName = ""
    
    @IBAction func doneFinish(sender: UIButton!){
        
        let date = NSDate()
        
        if self.timePick.hidden == false{
            print("time picker visible")
            print(date)
            print(self.timePick.date)
            
            for photoObj in gPhotoObjArr{
                if photoObj.fileName.compare(updateFileName) == NSComparisonResult.OrderedSame{
                    photoObj.created_time = self.timePick.date.timeIntervalSince1970
                    
                    //SEGAnalytics.sharedAnalytics().track("Updating Time of MealCard", properties: ["imageWidth": photoObj.width, "imageHeight": photoObj.height], options: ["integrations": ["created_date": NSDate.init(timeIntervalSince1970: photoObj.created_time), "tagArray": photoObj.tagArray, "filename": photoObj.fileName]])
                }
            }
            
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(gPhotoObjArr), forKey: "PhotoAlbum")
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if self.datePick.hidden == false{
            print("date picker visible")
            print(date)
            print(self.datePick.date)
            
            for photoObj in gPhotoObjArr{
                if photoObj.fileName.compare(updateFileName) == NSComparisonResult.OrderedSame{
                    photoObj.created_time = self.datePick.date.timeIntervalSince1970
                    
                    //SEGAnalytics.sharedAnalytics().track("Updating Date of MealCard", properties: ["imageWidth": photoObj.width, "imageHeight": photoObj.height], options: ["integrations": ["created_date": NSDate.init(timeIntervalSince1970: photoObj.created_time), "tagArray": photoObj.tagArray, "filename": photoObj.fileName]])
                }
            }
            
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(gPhotoObjArr), forKey: "PhotoAlbum")
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        photoTableView.reloadData()
        
        print("done")
        self.pickView.hidden = true
        self.timePick.hidden = true
        self.datePick.hidden = true
    }
    
    @IBAction func goCamera(sender: AnyObject!) {
        print("Nutrition Button")
        if let parentVC = self.parentViewController {
            if let parentVC = parentVC as? SnapChatPageViewController{
                parentVC.goHome(true)
            }
        }
    }
    
    @IBAction func goSetting(sender: AnyObject!) {
        print("Setting Button")
        if let parentVC = self.parentViewController {
            if let parentVC = parentVC as? SnapChatPageViewController{
                parentVC.goSettings(false)
            }
        }
    }
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //let indexPath = NSIndexPath(forRow: gPhotoObjArr.count - 1, inSection: 0)
        //   self.photoTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pickView.hidden = true
        self.datePick.hidden = true
        self.timePick.hidden = true
        
        doneBtn.layer.cornerRadius = 4.0
        doneBtn.layer.masksToBounds = true
        
        
        photoTableView.reloadData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func stringFromTimeInterval(fromDate : NSDate, toDate: NSDate) -> String{
        let sysCalendar = NSCalendar.currentCalendar()
        
        let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
        let components = sysCalendar.components(unitFlags, fromDate: fromDate, toDate: toDate, options: [])
        
        let comp = sysCalendar.components([.Hour, .Minute], fromDate: fromDate)
        let hour = comp.hour
        let minute = comp.minute
        
        var returnStr: String
        if components.month > 0{
            if components.month == 1{
                if hour > 12{
                    returnStr = String(format: "a month ago at %d:%d PM", components.month, hour - 12, minute)
                }else{
                    returnStr = String(format: "a months ago at %d:%d AM", components.month, hour, minute)
                }
                
                return returnStr
            }
            else{
                if hour > 12{
                    returnStr = String(format: "%d months ago at %d:%d PM", components.month, hour - 12, minute)
                }else{
                    returnStr = String(format: "%d months ago at %d:%d AM", components.month, hour, minute)
                }
                
                return returnStr
            }
        }
        
        if components.day > 0{
            if components.day == 1{
                if hour > 12{
                    returnStr = String(format: "Yesterday at %d:%d PM", hour - 12, minute)
                }else{
                    returnStr = String(format: "Yesterday at %d:%d AM", hour, minute)
                }
                
                return returnStr
            }
            else{
                
                if hour > 12{
                    returnStr = String(format: "%d days ago at %d:%d PM", components.day, hour - 12, minute)
                }else{
                    returnStr = String(format: "%d days ago at %d:%d AM", components.day, hour, minute)
                }
                
                return returnStr
            }
        }
        
        if components.hour > 0{
            if components.hour == 1{
                return "an hour ago"
            }
            else{
                returnStr = String(format: "%d hours ago", components.hour)
                return returnStr
            }
        }
        
        if components.minute > 0{
            if components.minute == 1{
                return "a min ago"
            }
            else{
                returnStr = String(format: "%d mins ago", components.minute)
                return returnStr
            }
        }
        
        return "a min ago"
    }
}

//MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
    }
}

//MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let ratio: CGFloat =  gPhotoObjArr[gPhotoObjArr.count - indexPath.row - 1].height / gPhotoObjArr[gPhotoObjArr.count - indexPath.row - 1].width
        
        print(UIScreen.mainScreen().bounds.size.width)
        return UIScreen.mainScreen().bounds.size.width * ratio
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gGetJSON == 0{
            return 0
        }
        return gPhotoObjArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let res = tableView.dequeueReusableCellWithIdentifier("HistoryPhotoCell", forIndexPath: indexPath) as! HistoryPhotoViewCell
        
        let indexSelPath = NSIndexPath(forRow: gPhotoObjArr.count - indexPath.row - 1, inSection: 0)
        
        let currentPhotoObj : PhotoObject = gPhotoObjArr[indexSelPath.row]
        
        res.photoData.image = UIImage(contentsOfFile: photoDirPath + currentPhotoObj.fileName)
        
        res.photoView.clipsToBounds = false
        
        res.photoView.layer.shadowColor = UIColor.grayColor().CGColor
        res.photoView.layer.shadowOffset = CGSizeMake(6, 4)

        res.photoView.layer.shadowRadius = 2
        
        res.photoView.layer.shadowOpacity = 0.8
        
        res.photoData.layer.cornerRadius = 3.0
        res.photoData.layer.masksToBounds = true
        
        let created_date = NSDate.init(timeIntervalSince1970: currentPhotoObj.created_time)
        let current_date = NSDate()
        print(created_date)
        
        res.tagArray = gPhotoObjArr[gPhotoObjArr.count - indexPath.row - 1].tagArray
        res.fileName = currentPhotoObj.fileName
        
        res.timeDate.text = stringFromTimeInterval(created_date, toDate: current_date)
        
        res.setTagInfo(gPhotoObjArr[gPhotoObjArr.count - indexPath.row - 1].tagArray)
        print(res.timeDate.text)
        
        //SEGAnalytics.sharedAnalytics().track("MealCard History", properties: ["imageWidth": (res.photoData.image?.size.width)!, "imageHeight": (res.photoData.image?.size.height)!], options: ["integrations": ["created_date": created_date, "tagArray": res.tagArray, "filename": res.fileName]])
        
        res.delegate = self
        
        return res
    }
    
    func onTouchNutritionButton(){
        print("Nutrition Button")
        if let parentVC = self.parentViewController {
            if let parentVC = parentVC as? SnapChatPageViewController{
                
                parentVC.goDetail(true)
            }
        }
    }
    
    
}

extension HistoryViewController: HistoryPhotoViewCellDelegate{
    func gotoDetailPage(historyPhotoCell: HistoryPhotoViewCell) {
        self.onTouchNutritionButton()

    }
    
    func alertAction(historyPhotoCell: HistoryPhotoViewCell) {
        print("alert Action")
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Share", style: UIAlertActionStyle.Default, handler: {
        (alert: UIAlertAction!) -> Void in

            print("Share")

            let activityItem: [AnyObject] = [historyPhotoCell.photoData.image as! AnyObject]
            
            let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
            
            self.presentViewController(avc, animated: true, completion: nil)
        
        }))
        
        alert.addAction(UIAlertAction(title: "Save to Camera roll", style: UIAlertActionStyle.Default, handler: {
        (alert: UIAlertAction!) -> Void in
            print("Save to Camera roll")
            
            UIImageWriteToSavedPhotosAlbum(historyPhotoCell.photoData.image!, nil, nil, nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Edit Tags", style: UIAlertActionStyle.Default, handler: {
        (alert: UIAlertAction!) -> Void in

            print(historyPhotoCell.tagArray.count)
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcAddTagViewController") as! AddTagViewController
            vc.imageData = historyPhotoCell.photoData.image
            vc.width = historyPhotoCell.photoData.image!.size.width
            vc.height = historyPhotoCell.photoData.image!.size.height
            vc.tagSelectedArray = historyPhotoCell.tagArray
            vc.selectedFilename = historyPhotoCell.fileName
            vc.flgSave = false
            
            vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Edit Time Eaten", style: UIAlertActionStyle.Default, handler: {
        (alert: UIAlertAction!) -> Void in
            //            self.shareLocation()
            print("Edit Time Eaten")

            self.alertEditEatenTimeAction(historyPhotoCell)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Delete Mealcard", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.deleteItem(historyPhotoCell)
            
            self.photoTableView.reloadData()
            
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(gPhotoObjArr), forKey: "PhotoAlbum")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
        (alert: UIAlertAction!) -> Void in
        }))

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteItem(historyPhotoCell: HistoryPhotoViewCell){
        
        print("Delete Item")
        self.updateFileName = historyPhotoCell.fileName
        
        var nIndex = 0
        for photoObj in gPhotoObjArr{
            if photoObj.fileName.compare(self.updateFileName) == NSComparisonResult.OrderedSame{
                gPhotoObjArr.removeAtIndex(nIndex)
                
                let deletePath = photoDirPath + self.updateFileName
                
                // Create a FileManager instance
                
                let fileManager = NSFileManager.defaultManager()
                
                // Delete 'hello.swift' file
                
                do {
                    try fileManager.removeItemAtPath(deletePath)
                }
                catch let error as NSError {
                    print("Ooops! Something went wrong: \(error)")
                }
            }
            
            nIndex += 1
        }
        
        
    }
    
    func alertEditEatenTimeAction(historyPhotoCell: HistoryPhotoViewCell){
        let alertEatenTime = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        self.updateFileName = historyPhotoCell.fileName
        
        alertEatenTime.addAction(UIAlertAction(title: "Edit the Time", style: UIAlertActionStyle.Default, handler: {
            (alertEatenTime: UIAlertAction!) -> Void in

            self.pickView.hidden = false
            self.timePick.hidden = false
            
            print(self.timePick.date)
            print("Edit Time")
            
        }))
        
        alertEatenTime.addAction(UIAlertAction(title: "Edit the Date", style: UIAlertActionStyle.Default, handler: {
            (alertEatenTime: UIAlertAction!) -> Void in
            
            self.pickView.hidden = false
            self.datePick.hidden = false
            
            print(historyPhotoCell.tagArray)
            print(historyPhotoCell.fileName)
           
        }))
        
        alertEatenTime.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        }))
        
        self.presentViewController(alertEatenTime, animated: true, completion: nil)
        
    }
    
}


