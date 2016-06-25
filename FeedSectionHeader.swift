//
//  FeedSectionHeader.swift
//  ParsePics
//
//  Created by Amy Xiong on 6/24/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import ParseUI

class FeedSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var post: PFObject! {
        didSet {
            // set timestamp
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EE, M/dd/yy h:mm a"
            let timestamp = dateFormatter.stringFromDate(post.createdAt!)
            self.timestampLabel!.text = timestamp
            
            let user = post["author"] as? PFUser
            self.userLabel!.text = user!.username
        }
    }
}
