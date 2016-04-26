//
//  Constant.swift
//  MealTracker
//
//  Created by Valti Skobo on 01/04/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import Foundation
import UIKit

var iOS_String = ""

var gArrDescription : NSMutableArray!

var gGetJSON = 0

var gReadTermAlready = 0

var gFlgSaveCameraRoll = false

var gSearchBarText = ""

let photoDirPath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String) + "/"

class PhotoObject: NSObject, NSCoding {
    // MARK: Properties
    var tagArray : [String]
    var fileName : String
    var created_time: NSTimeInterval
    var width : CGFloat
    var height : CGFloat
    
    init(created_time:NSTimeInterval, fileName: String, tagArray: [String], width: CGFloat, height: CGFloat) {
        // Initialize stored properties.
        self.created_time = created_time
        self.fileName = fileName
        self.tagArray = tagArray
        self.width = width
        self.height = height
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(tagArray, forKey: "tagArray")
        aCoder.encodeObject(fileName, forKey: "fileName")
        aCoder.encodeObject(created_time, forKey: "created_time")
        aCoder.encodeObject(width, forKey: "width")
        aCoder.encodeObject(height, forKey: "height")
        
        
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        self.tagArray = aDecoder.decodeObjectForKey("tagArray") as! [String]
        self.fileName = aDecoder.decodeObjectForKey("fileName") as! String
        self.created_time = aDecoder.decodeObjectForKey("created_time") as! NSTimeInterval
        self.width = aDecoder.decodeObjectForKey("width") as! CGFloat
        self.height = aDecoder.decodeObjectForKey("height") as! CGFloat
        
    }
    
}

class CustomButton: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).CGPath
            shadowLayer.fillColor = UIColor.whiteColor().CGColor
            
            shadowLayer.shadowColor = UIColor.darkGrayColor().CGColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, atIndex: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }        
    }
    
}

var gPhotoObjArr : [PhotoObject]!
