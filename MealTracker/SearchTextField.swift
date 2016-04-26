//
//  SearchTextField.swift
//  MealTracker
//
//  Created by Sergey Rashidov on 19/04/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    override func drawPlaceholderInRect(rect: CGRect) {
        
        guard let text = self.placeholder else {
            return
        }
        
        let placeholder = NSString(string: text)
        let color = UIColor.lightGrayColor()
        let attributes = [NSForegroundColorAttributeName:color]
        
        let boundingRect = placeholder.boundingRectWithSize(rect.size, options: NSStringDrawingOptions(rawValue: 0), attributes: attributes, context: nil)
        placeholder.drawAtPoint(CGPointMake((rect.size.width/2)-boundingRect.size.width/2, (rect.size.height/2)-boundingRect.size.height/2), withAttributes: attributes)
        
    }
    
}
