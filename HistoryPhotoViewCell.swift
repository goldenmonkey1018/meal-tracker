//
//  HistoryPhotoViewCell.swift
//  MealTracker
//
//  Created by Valti Skobo on 08/04/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit

import TTGTagCollectionView
import SwiftHEXColors


protocol HistoryPhotoViewCellDelegate: NSObjectProtocol {
    
    func gotoDetailPage(historyPhotoCell: HistoryPhotoViewCell)
    
    func alertAction(historyPhotoCell: HistoryPhotoViewCell)
}



class HistoryPhotoViewCell: UITableViewCell {
    @IBOutlet weak var timeDate: UILabel!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var photoData: UIImageView!
    
    @IBOutlet weak var tagPhotoView: TTGTagCollectionView!
    
    @IBOutlet weak var tagListViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: HistoryPhotoViewCellDelegate?
    
    var tagViews : [UIView] = []
    var tagArray : [String] = []
    var fileName : String = ""
    
    @IBAction func didPressOption(sender: UIButton!) {
        self.delegate?.alertAction(self)
    }
    
    func newButtonWithTitle(title: String, fontSize: CGFloat, backgroundColor : UIColor) -> UIButton{
        //AMTagView.appearance().tagText = title
        //AMTagView.appearance().tagLength = 10
        //AMTagView.appearance().textFont = UIFont(name: "System", size: 14)
        //AMTagView.appearance().tagColor = backgroundColor
        //AMTagView.appearance().innerTagColor = backgroundColor
        
        let button = UIButton.init()
        
        //let buttonImage = UIImage.init(named: "tag")
        
        //button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        
        
        button.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        button.setTitle(title, forState: UIControlState.Normal)
        
        //button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = backgroundColor
        button.sizeToFit()
        
        /*
        button.clipsToBounds = false;
        
        button.layer.shadowColor = UIColor.grayColor().CGColor
        button.layer.shadowOffset = CGSizeMake(0, 2)
        button.layer.shadowRadius = 4
        
        button.layer.shadowOpacity = 0.8
        
        button.layer.cornerRadius = 2.0 */
//        button.layer.masksToBounds = true

        button.layer.cornerRadius = 3.0
        
        self.expandSizeForView(button, extraWidth: 12, extraHeight: -6)
        
        button.addTarget(self, action: "onButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }
    
    func onButtonClicked(button: UIButton){
        print(button.titleLabel!.text)
    
        let s: String = button.titleLabel!.text!
        var ss1: String = (s as NSString).substringToIndex(1)
        
        if ss1.compare("●") == NSComparisonResult.OrderedSame{
            ss1 = s.substringFromIndex(s.startIndex.advancedBy(2))
        }
        else{
            ss1 = s
        }
        print(ss1)
        //print(button.titleLabel!.text?.substringToIndex(1))
    
        if button.backgroundColor != UIColor.grayColor(){
            gSearchBarText = ss1
            self.delegate?.gotoDetailPage(self)
        }
    }
    
    func expandSizeForView(view: UIView!, extraWidth: CGFloat, extraHeight: CGFloat){
        var frame: CGRect!
        frame = view.frame
        frame.size.width += extraWidth
        frame.size.height += extraHeight
        view.frame = frame
    }
        
    func setTagInfo (tagArray: [String]){
        
        tagViews.removeAll()
        tagPhotoView.backgroundColor = UIColor.clearColor()
        
        tagPhotoView.verticalSpacing = 9.0
        tagPhotoView.horizontalSpacing = 9.0
       
        tagPhotoView.delegate = self;
        tagPhotoView.dataSource = self;
        
        for tagString in tagArray{
            
            let buttonString = "● " + tagString
            var bgColor : UIColor! = UIColor.init(hexString: "#0099FF")
            for item in gArrDescription{
                let itemData = item as! NSDictionary
                
                let tagItemString = itemData.valueForKey("Tag Name") as! String

                if tagString.compare(tagItemString) == NSComparisonResult.OrderedSame{
                    let itemColor = itemData.valueForKey("Color") as! String
                    if itemColor.compare("Invalid color") == NSComparisonResult.OrderedSame {
                        bgColor = UIColor.redColor()
                    }
                    else if itemColor.compare("") == NSComparisonResult.OrderedSame {
                        bgColor = UIColor.init(hexString: "#0099FF")
                    }else{
                        bgColor = UIColor.init(hexString: itemColor)
                    }
                }
            }
            
            tagViews.append(self.newButtonWithTitle(buttonString, fontSize: 13.0, backgroundColor: bgColor))
        }
        
        if tagArray.count <= 3{
            tagListViewHeightConstraint.constant = 25
        }
        else{
            tagListViewHeightConstraint.constant = 55
        }
        
        tagPhotoView.reload()
    }
}

//MARK: - TTGTagCollectionViewDataSource
extension HistoryPhotoViewCell: TTGTagCollectionViewDataSource {
    func numberOfTagsInTagCollectionView(tagCollectionView: TTGTagCollectionView!) -> UInt {
        print(UInt(tagViews.count))
        return UInt(tagViews.count)
    }
    
    func tagCollectionView(tagCollectionView: TTGTagCollectionView!, tagViewForIndex index: UInt) -> UIView! {
        return tagViews[Int(index)];
    }
}

//MARK: - TTGTagCollectionViewDelegate
extension HistoryPhotoViewCell: TTGTagCollectionViewDelegate {
    func tagCollectionView(tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, atIndex index: UInt) {
        print(index)
    }
    
    func tagCollectionView(tagCollectionView: TTGTagCollectionView!, sizeForTagAtIndex index: UInt) -> CGSize {
        print(index)
        return tagViews[Int(index)].frame.size;
    }
    
    func tagCollectionView(tagCollectionView: TTGTagCollectionView!, updateContentHeight newContentHeight: CGFloat) {
        print(newContentHeight)
    }
}