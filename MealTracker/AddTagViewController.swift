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

//import SKTagView
//import TagListView

import Analytics

import TTGTagCollectionView

protocol AddTagViewControllerDelegate: NSObjectProtocol {
    
    func addTagViewControllerDidFinish(addTagViewController: AddTagViewController)
    
}

class AddTagViewController: UIViewController{
    weak var delegate: AddTagViewControllerDelegate?
    var imageData: UIImage!
    var width : CGFloat = 0
    var height : CGFloat = 0
    
    var flgSave : Bool = true
    
    var tagSelectedArray : [String] = []
    
    var tagTempSelectedArray : [String] = []
    var selectedFilename : String = ""
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tagListView: TTGTextTagCollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var textField: UITextField!
    
    var tempDescArray = (gArrDescription != nil) ? NSMutableArray(array: gArrDescription) : NSMutableArray()
    
    var customTagArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(width)
        print(height)
        
        tagListView.delegate = self

        //tagListView.tagTextFont = UIFont.boldSystemFontOfSize(17.0)
        tagListView.tagTextFont = UIFont.systemFontOfSize(17.0)

        tagListView.horizontalSpacing = 5.0;
        tagListView.verticalSpacing = 5.0;
        
        //tagListView.frame = CGRectMake(0, 0, 320, 240)
        
        tagListView.horizontalSpacing = 11
        tagListView.verticalSpacing = 11
        
        tagListView.backgroundColor = UIColor.clearColor()
        tagListView.extraSpace = CGSizeMake(12, 12);
        
        tagListView.tagTextColor = UIColor.init(colorLiteralRed: 60/256, green: 225/256, blue: 143/256, alpha: 1)
        tagListView.tagSelectedTextColor = UIColor.init(colorLiteralRed: 255/256, green: 255/256, blue: 255/256, alpha: 1)
        tagListView.tagBackgroundColor = UIColor.clearColor()
        tagListView.tagSelectedBackgroundColor = UIColor.init(colorLiteralRed: 60/256, green: 225/256, blue: 143/256, alpha: 1)
        
        tagListView.tagCornerRadius = 3.0;
        tagListView.tagSelectedCornerRadius = 3.0;
        tagListView.tagBorderWidth = 1.0;
        tagListView.tagSelectedBorderWidth = 1.0;
        tagListView.tagBorderColor = UIColor.init(colorLiteralRed: 60/256, green: 225/256, blue: 143/256, alpha: 1)

        tagListView.tagSelectedBorderColor = UIColor.init(colorLiteralRed: 60/256, green: 225/256, blue: 143/256, alpha: 1)
        
        showImage()
        addTagView()
        
        showSelectedTags(tagSelectedArray)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func goCamera(sender: AnyObject!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showSelectedTags(tagSelectedArray : [String]){
        
        let allTagArray : [String] = tagListView.allTags()
        for selectedTagItem in tagSelectedArray{
            
            var index = 0
            for itemTag in allTagArray{
                if selectedTagItem.compare(itemTag) == NSComparisonResult.OrderedSame{
                    tagListView.setTagAtIndex(UInt(index), selected: true)
                }
                
                index += 1
            }
        }
    }
    
    func mergeTagArray(var tagMergedArray : [String], tagMergeArray : [String]) -> [String] {
        for mergedItem in tagMergedArray{
            for mergeItem in tagMergeArray{
                if mergedItem.compare(mergeItem) != NSComparisonResult.OrderedSame{
                    tagMergedArray.append(mergeItem)
                }
            }
        
        }
        
        return tagMergedArray
    }
    
    func addTagView(){
        if gArrDescription == nil{
            return
        }
        
        /*
        for selectedTagItem in tagSelectedArray{
            var boolCustomTag = true
            
            for item in tempDescArray{
                let itemData = item as! NSDictionary
                
                let tagString = itemData.valueForKey("Tag Name") as! String
                
                if selectedTagItem.compare(tagString) != NSComparisonResult.OrderedSame{
                    boolCustomTag = false
                }
            }
            
            if boolCustomTag == false{
                tagListView.addTag(selectedTagItem)
            }
        }*/
        
        for item in tempDescArray{
            let itemData = item as! NSDictionary
            
            tagListView.addTag(itemData.valueForKey("Tag Name") as! String)
        }
        
        tagListView.hidden = false
        contentView.addSubview(tagListView)
    }
    
    func showImage(){
        let imageView : UIImageView!
        imageView = UIImageView.init(frame: CGRectMake(0, 25, UIScreen.mainScreen().bounds.width,
                                                        UIScreen.mainScreen().bounds.width * height / width))
        
        imageView.image = imageData
        imageView.alpha = 0.5
        contentView.addSubview(imageView)
    }
    
    
    @IBAction func goHistory(sender: AnyObject!) {
        let selectedTagsArray : [String] = tagListView.allSelectedTags()
        
        if flgSave == true{
            
            let fileName = NSUUID().UUIDString + ".jpg"
            let destinationPath = photoDirPath + fileName
            
            UIImageJPEGRepresentation(imageData, 0.8)!.writeToFile(destinationPath, atomically: true)
            
            if gFlgSaveCameraRoll == true{
                UIImageWriteToSavedPhotosAlbum(imageData, nil, nil, nil)
            }
            
            let photoObj = PhotoObject(created_time: NSDate().timeIntervalSince1970, fileName: fileName, tagArray: selectedTagsArray, width: width, height: height)
            
            gPhotoObjArr.append(photoObj)
            
            print(gPhotoObjArr.count)
            
            //SEGAnalytics.sharedAnalytics().track("Adding MealCard", properties: ["imageWidth": width, "imageHeight": height], options: ["integrations": ["created_date": NSDate(), "tagArray": selectedTagsArray, "filename": destinationPath]])
            
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(gPhotoObjArr), forKey: "PhotoAlbum")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.delegate?.addTagViewControllerDidFinish(self)
        }
        else{
            print(self.tagSelectedArray.count)
            print(selectedFilename)
            
            for photoObj in gPhotoObjArr{
                if photoObj.fileName.compare(selectedFilename) == NSComparisonResult.OrderedSame{
                    photoObj.tagArray = selectedTagsArray
                    
                    //SEGAnalytics.sharedAnalytics().track("Updating MealCard", properties: ["imageWidth": photoObj.width, "imageHeight": photoObj.height], options: ["integrations": ["created_date": NSDate.init(timeIntervalSince1970: photoObj.created_time), "tagArray": selectedTagsArray, "filename": photoObj.fileName]])
                }
            }
            
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(gPhotoObjArr), forKey: "PhotoAlbum")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        //let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcHistoryViewController") as? HistoryViewController
        //self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}


//#MARK: - UITextFieldDelegate
extension AddTagViewController : UITextFieldDelegate{
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newText = (textField.text as! NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        // do with newText
        print(newText)
        
        var allSelectedTagArray : [String] = tagListView.allSelectedTags()
        allSelectedTagArray = mergeTagArray(allSelectedTagArray, tagMergeArray: tagTempSelectedArray)
        
        tempDescArray.removeAllObjects()
        tagListView.removeAllTags()
        
        for item in gArrDescription{
            let itemData = item as! NSDictionary
            
            var tagString = itemData.valueForKey("Tag Name") as! String
            tagString = tagString.lowercaseString
            
            if tagString.containsString(newText.lowercaseString) == true{
                print(itemData.valueForKey("Tag Name") as! String)
                
                tempDescArray.addObject(itemData)
            }
            else if newText.compare("") == NSComparisonResult.OrderedSame{
                tempDescArray.addObject(itemData)
            }
        }
        
        /*var nSelectIndex = 0
        for item in tempDescArray{
            let itemData = item as! NSDictionary
            
            let searchedTagString = itemData.valueForKey("Tag Name") as! String
            
            for selectedTagString in arllSelectedTagArray{
                if searchedTagString.compare(selectedTagString) == NSComparisonResult.OrderedSame{
                    tagListView.setTagAtIndex(UInt(nSelectIndex), selected: true)
                }
                
                nSelectIndex += 1
            }
        }*/
        
        tagListView.addTag(newText)
        
        for item in customTagArray{
            let itemData = item as! NSDictionary
            var tagString = itemData.valueForKey("Tag Name") as! String
            tagString = tagString.lowercaseString
            
            if tagString.containsString(newText.lowercaseString) == true{
                print(itemData.valueForKey("Tag Name") as! String)
                
                tagListView.addTag(itemData.valueForKey("Tag Name") as! String)
            }
            else if newText.compare("") == NSComparisonResult.OrderedSame{
                tagListView.addTag(itemData.valueForKey("Tag Name") as! String)
            }
        }

        for item in tempDescArray{
            let itemData = item as! NSDictionary
            
            tagListView.addTag(itemData.valueForKey("Tag Name") as! String)
        }
        
        showSelectedTags(allSelectedTagArray)
        tagTempSelectedArray = allSelectedTagArray
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        var allSelectedTagArray : [String] = tagListView.allSelectedTags()
        allSelectedTagArray = mergeTagArray(allSelectedTagArray, tagMergeArray: tagTempSelectedArray)
        
        tempDescArray.removeAllObjects()
        tagListView.removeAllTags()
        
        let tagString = textField.text
        
        let itemData : [String : String] =
        [
            "Tag Name": tagString!
        ]
        
        customTagArray.addObject(itemData)
        
        for item in gArrDescription{
            let itemData = item as! NSDictionary
            tempDescArray.addObject(itemData)
            
            tagListView.addTag(itemData.valueForKey("Tag Name") as! String)
        }
        
        for item in customTagArray{
            let itemData = item as! NSDictionary;
            
            tagListView.addTag(itemData.valueForKey("Tag Name") as! String)
        }
        
        showSelectedTags(allSelectedTagArray)
        tagTempSelectedArray = allSelectedTagArray
        
        textField.resignFirstResponder()

        return true
    }
}

//MARK: - UISearchBarDelegate
extension AddTagViewController : UISearchBarDelegate{
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        tempDescArray.removeAllObjects()
        tagListView.removeAllTags()
        
        for item in gArrDescription{
            let itemData = item as! NSDictionary
            
            var tagString = itemData.valueForKey("Tag Name") as! String
            tagString = tagString.lowercaseString
            
            if tagString.containsString(searchText.lowercaseString) == true{
                print(itemData.valueForKey("Tag Name") as! String)
                
                tempDescArray.addObject(itemData)
            }
            else if searchBar.text?.compare("") == NSComparisonResult.OrderedSame{
                tempDescArray.addObject(itemData)
            }
        }
        
        
        for item in tempDescArray{
            let itemData = item as! NSDictionary
            
            tagListView.addTag(itemData.valueForKey("Tag Name") as! String)
            
        }
        
        //addTagView()
        //tagTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("clicked Done")
    }
}

//MARK: - TTGTextTagCollectionViewDelegate
extension AddTagViewController: TTGTextTagCollectionViewDelegate{
    
    func textTagCollectionView(textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, atIndex index: UInt, selected: Bool) {
        //_logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld, selected: %d", tagText, (long) index, selected];
        
        var flagCustomTag = true
        for item in gArrDescription{
            let itemData = item as! NSDictionary
            
            var tagString = itemData.valueForKey("Tag Name") as! String
            tagString = tagString.lowercaseString
            
            if tagString.compare(tagText.lowercaseString) == NSComparisonResult.OrderedSame{
                flagCustomTag = false
            }
        }
        
        if flagCustomTag == true{
            let itemData : [String : String] =
            [
                "Tag Name": tagText!
            ]
            
            customTagArray.addObject(itemData)
        }
        
        if selected == true{
            textTagCollectionView.setTagAtIndex(UInt(index), selected: true)
        }
        else{
            textTagCollectionView.setTagAtIndex(UInt(index), selected: false)
        }
        
        print(tagText)
        print(index)
        print(selected)
    }
    
    func textTagCollectionView(textTagCollectionView: TTGTextTagCollectionView!, updateContentHeight newContentHeight: CGFloat) {
        
        print(newContentHeight)
    }
    /*func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        print(title)
        print(tagView.selected)

        tagView.selected = !tagView.selected
        //sender.tagViews[0].select(sender)
        
    }
    func tagRemoveButtonPressed(title: String, tagView: TagView, sender: TagListView) {
        print("Remove 'title'")
    }*/
}
