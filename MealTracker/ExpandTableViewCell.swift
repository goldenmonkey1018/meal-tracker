//
//  ExpandableTableViewCell.swift
//  ExpandableTableView
//
//  Created by Valti Skobo on 06/05/15.
//  Copyright (c) 2015 Valti Skobo. All rights reserved.
//

import UIKit

typealias ActionHandler = (UIButton, NSIndexPath) -> Void

let detailViewDefaultHeight: CGFloat = 350
let lowLayoutPriority: Float = 350
let highLayoutPriority: Float = 999

class ExpandableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var dotHeader: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var textDescription: UILabel!
    
    @IBOutlet weak var detailViewHeightConstraint: NSLayoutConstraint!
    
    var showsDetails = false {
        didSet {
            detailViewHeightConstraint.priority = showsDetails ?  lowLayoutPriority : highLayoutPriority
        }
    }
    
    var detailButtonActionHandler: ActionHandler = { _ in }
    var indexPath = NSIndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailViewHeightConstraint.constant = 0
        
    }
    
    var mainTitle: String! {
        didSet {
            tagName.text = mainTitle
        }
    }
    
    @IBAction private func didPressDetailButton(sender: UIButton) {
        detailButtonActionHandler(sender, indexPath)
    }
}
